import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../constants/home_dimensions.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(AppDimensions.searchBarHeight),
      padding: EdgeInsets.symmetric(horizontal: context.w(AppDimensions.lg)),
      decoration: BoxDecoration(
        color: context.appColors.searchBarBackground,
        border: Border.all(
          color: context.appColors.searchBorder,
          width: AppBorderWidth.hairline,
        ),
        borderRadius: BorderRadius.circular(context.r(AppRadius.md)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: context.r(AppIconSize.sm),
            color: context.appColors.searchIcon,
          ),
          SizedBox(width: context.w(HomeDimensions.searchIconGap)),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: context.textStyles.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search for plants',
                hintStyle: context.textStyles.bodyMedium
                    ?.copyWith(color: context.appColors.searchHint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
