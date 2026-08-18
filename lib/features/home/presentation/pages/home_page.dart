import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../domain/entities/plant_category.dart';
import '../../domain/entities/question.dart';
import '../bloc/home_bloc.dart';
import '../constants/home_assets.dart';
import '../constants/home_dimensions.dart';
import '../widgets/category_card.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_tab_bar.dart';
import '../widgets/premium_banner.dart';
import '../widgets/question_card.dart';

@RoutePage()
class HomePage extends StatelessWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<HomeBloc>(
    create: (_) => getIt<HomeBloc>()..add(const HomeEvent.started()),
    child: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: context.appColors.scaffoldBackground,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
          // isBusy covers both HomeStatus.loading (first load) and
          // .refreshing (pull-to-refresh / the error screen's "Try again")
          // — checking only .loading here missed the retry case: it fell
          // through to _HomeContent with an empty list mid-fetch, showing
          // the header/search bar before any data had actually arrived.
          if (state.isBusy && !state.hasContent) {
            return const LoadingView();
          }
          if (state.showFullScreenError) {
            return ErrorView(
              failure: state.failure!,
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeEvent.refreshed()),
            );
          }
          return _HomeContent(state: state);
        },
      ),
      bottomNavigationBar: HomeTabBar(
        currentIndex: HomeConstants.initialTabIndex,
        onTabSelected: (_) {},
        onScanPressed: () {},
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.state});

  final HomeState state;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Runs once, the first time loading finishes and this widget actually
    // mounts (LoadingView and _HomeContent are different widget types, so
    // Flutter tears down and rebuilds fresh here rather than reusing state)
    // — not on every later rebuild, e.g. while typing in search.
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.homeEntrance,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = context.read<HomeBloc>();
    final double gutter = context.w(AppDimensions.pageHorizontal);
    final List<Question> questions = widget.state.questions;

    return RefreshIndicator(
      color: context.appColors.primary,
      onRefresh: () async => bloc.add(const HomeEvent.refreshed()),
      child: Padding(
        padding: EdgeInsets.only(bottom: context.h(AppDimensions.tabBarHeight)),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _FadeSlideIn(
                animation: _stagger(
                  _controller,
                  start: AppStagger.headerStart,
                  span: AppStagger.sectionSpan,
                ),
                child: _Header(
                  gutter: gutter,
                  onSearchChanged: (String query) =>
                      bloc.add(HomeEvent.searchChanged(query)),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: context.h(AppDimensions.xxl)),
            ),
            SliverToBoxAdapter(
              child: _FadeSlideIn(
                animation: _stagger(
                  _controller,
                  start: AppStagger.bannerStart,
                  span: AppStagger.sectionSpan,
                ),
                child: PremiumBanner(onTap: () {}),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: context.h(AppDimensions.xxl)),
            ),
            if (questions.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: context.h(AppDimensions.questionCardHeight),
                  child: ListView.separated(
                    scrollCacheExtent: ScrollCacheExtent.pixels(context.w(AppDimensions.questionCardWidth) * 2), scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    itemCount: questions.length,
                    // Lazy: only the visible cards are built and their images
                    // fetched.
                    itemBuilder: (BuildContext context, int index) {
                      return _FadeSlideIn(
                        // Each card enters slightly after the one before it,
                        // capped so a long row doesn't push the tail end of
                        // the stagger past the controller's own duration.
                        animation: _stagger(
                          _controller,
                          start: AppStagger.questionsStart +
                              AppStagger.questionStep *
                                  index.clamp(
                                    AppStagger.firstStep,
                                    AppStagger.questionMaxSteps,
                                  ),
                          span: AppStagger.cardSpan,
                        ),
                        child: QuestionCard(
                          question: questions[index],
                          index: index,
                          total: questions.length,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext _, int __) => SizedBox(
                      width: context.w(HomeDimensions.questionSpacing),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: context.h(AppDimensions.xxl)),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              sliver: _CategoryGrid(
                categories: widget.state.visibleCategories,
                controller: _controller,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: context.h(AppDimensions.xxxl)),
            ),
          ],
        ),
      ),
    );
  }
}

/// A staggered sub-window of [controller]: starts at [start] (a 0-1 fraction
/// of the controller's total duration) and runs for [span]. Both are clamped
/// so a large `start` (e.g. a card far down a long list) degrades to "already
/// visible" instead of throwing — [Interval] requires begin < end.
Animation<double> _stagger(
    AnimationController controller, {
      required double start,
      required double span,
    }) {
  // Capped below the end of the timeline (not clamped to it) so `end` always
  // has room to land strictly above `begin` after its own clamp.
  final double begin = start.clamp(AppStagger.timelineStart, AppStagger.maxStart);
  final double end = (begin + span)
      .clamp(AppStagger.timelineStart, AppStagger.timelineEnd);
  return CurvedAnimation(
    parent: controller,
    curve: Interval(
      begin,
      end > begin ? end : AppStagger.timelineEnd,
      curve: AppMotion.enter,
    ),
  );
}

/// Fades in and rises slightly into place. Used for every section/card on
/// first load so content settles in piece by piece instead of popping in
/// all at once.
class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: AppMotion.enterSlideOffset,
          end: AppMotion.restOffset,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.gutter, required this.onSearchChanged});

  final double gutter;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.hWithSafeTop(151),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            context.isDarkMode
                ? HomeAssets.headerBackgroundDark
                : HomeAssets.headerBackground,
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: Stack(
        children: <Widget>[
          // Blends the photo's own tone into the flat scaffold colour below
          // it — the two are independent sources of "dark" (an exported PNG
          // vs. our own AppColors token) and won't land on the exact same
          // hex by luck, so a hard cut between them reads as a visible seam.
          // The top 60% stays fully clear so the greeting text's photo
          // backdrop isn't washed out; only the last stretch fades out.
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: context.hWithSafeTop(AppDimensions.xl)),
                Text('Hi, plant lover!', style: context.textStyles.bodyLarge),
                SizedBox(height: context.h(AppDimensions.xsPlus)),
                Text(_greeting(), style: context.textStyles.headlineSmall),
                SizedBox(height: context.h(AppDimensions.lg)),
                HomeSearchBar(onChanged: onSearchChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final int hour = DateTime.now().hour;
    if (hour < HomeConstants.morningEndsHour) return 'Good Morning! 🌤️';
    if (hour < HomeConstants.afternoonEndsHour) return 'Good Afternoon! ⛅';
    return 'Good Evening! 🌙';
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories, required this.controller});

  final List<PlantCategory> categories;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding:
          EdgeInsets.symmetric(vertical: context.h(AppDimensions.xxxl)),
          child: Text(
            'No categories match your search. Try a different plant name.',
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLarge,
          ),
        ),
      );
    }

    return SliverGrid.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive.isExpanded
            ? HomeDimensions.gridColumnsExpanded
            : HomeDimensions.gridColumnsCompact,
        mainAxisSpacing: context.h(AppDimensions.lg),
        crossAxisSpacing: context.w(AppDimensions.lg),
      ),
      itemBuilder: (BuildContext context, int index) => _FadeSlideIn(
        animation: _stagger(
          controller,
          start: AppStagger.categoriesStart +
              AppStagger.categoryStep *
                  index.clamp(
                    AppStagger.firstStep,
                    AppStagger.categoryMaxSteps,
                  ),
          span: AppStagger.cardSpan,
        ),
        child: CategoryCard(
          category: categories[index],
          index: index,
          total: categories.length,
        ),
      ),
    );
  }
}