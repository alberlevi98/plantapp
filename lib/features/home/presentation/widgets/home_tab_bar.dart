import 'package:flutter/material.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../constants/home_assets.dart';
import '../constants/home_dimensions.dart';

/// Bottom navigation with the raised circular scan button.
/// Purely presentational — tab changes are reported through [onTabSelected].
class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.onScanPressed,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onScanPressed;

  /// The tabs, as data. Previously these were `Image.asset(...)` widgets
  /// built in a field initializer, which forced this widget to be
  /// non-`const` and rebuilt four Images on every construction.
  static const List<_TabItem> _items = <_TabItem>[
    _TabItem(asset: HomeAssets.tabHomeIcon, label: 'Home'),
    _TabItem(asset: HomeAssets.tabDiagnoseIcon, label: 'Diagnose'),
    _TabItem(asset: HomeAssets.tabMyGardenIcon, label: 'My Garden'),
    _TabItem(asset: HomeAssets.tabProfileIcon, label: 'Profile'),
  ];

  /// Indices of the tabs that sit left and right of the scan button.
  static const List<int> _leadingTabs = <int>[0, 1];
  static const List<int> _trailingTabs = <int>[2, 3];

  @override
  Widget build(BuildContext context) {
    final double barHeight = context.hWithSafeBottom(AppDimensions.tabBarHeight);
    final double scanSize = context.r(HomeDimensions.scanButtonSize);

    // The scan button straddles the bar's top edge, so the whole widget has
    // to be half a button taller than the bar itself.
    final double scanOverhang = scanSize / AppScale.half;

    return SizedBox(
      height: barHeight + scanOverhang,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: context.appColors.tabBarBackground,
              border: Border(
                top: BorderSide(
                  color: context.appColors.tabBarBorder,
                  width: AppBorderWidth.regular,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: <Widget>[
                  for (final int index in _leadingTabs)
                    Expanded(child: _tab(context, index)),
                  SizedBox(width: scanSize),
                  for (final int index in _trailingTabs)
                    Expanded(child: _tab(context, index)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: barHeight - scanOverhang,
            child: _ScanButton(size: scanSize, onPressed: onScanPressed),
          ),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, int index) {
    final _TabItem item = _items[index];
    final bool isActive = index == currentIndex;

    return Semantics(
      excludeSemantics: true,
      selected: isActive,
      button: true,
      label: item.label,
      child: InkResponse(
        onTap: () => onTabSelected(index),
        child: Padding(
          padding: EdgeInsets.only(
            top: context.h(HomeDimensions.tabItemTopSpacing),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Not tinted. The original code computed an active/inactive
              // icon colour and then never applied it, so the icons render
              // today exactly as exported — that behaviour is preserved
              // rather than silently changed. If the assets turn out to be
              // monochrome/alpha-shaped, add
              // `color: isActive ? context.appColors.primary
              //                  : context.appColors.tabInactiveIcon`
              // here; on full-colour PNGs it would flatten them instead.
              Image.asset(
                fit: BoxFit.contain,
                item.asset,
                width: context.r(HomeDimensions.tabIconSize),
                height: context.r(HomeDimensions.tabIconSize),
                excludeFromSemantics: true,
              ),
              SizedBox(height: context.h(HomeDimensions.tabIconLabelSpacing)),
              Text(
                item.label,
                maxLines: AppTextLimits.singleLine,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelSmall?.copyWith(
                  color: isActive
                      ? context.appColors.primary
                      : context.appColors.tabInactiveLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.size, required this.onPressed});

  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Identify a plant with the camera',
      child: GestureDetector(
        onTap: onPressed,
        child: Image.asset(
          HomeAssets.tabScanIcon,
          fit: BoxFit.contain,
          width: size,
          height: size,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.asset, required this.label});

  final String asset;
  final String label;
}
