import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonTitle;
  final String? buttonSuffixIcon;
  final Color? buttonBackgroundColor;
  final EdgeInsets? buttonMainMargin;
  final EdgeInsets? buttonContentPadding;

  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.buttonTitle,
    this.buttonSuffixIcon,
    this.buttonBackgroundColor,
    this.buttonMainMargin,
    this.buttonContentPadding,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(buttonTitle),
            const SizedBox(width: 8),
            SvgPicture.asset(
              buttonSuffixIcon ?? 'assets/icons/fast_wind.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
