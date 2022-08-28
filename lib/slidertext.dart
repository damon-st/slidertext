library slidertext;

import 'dart:async';

import 'package:flutter/material.dart';

class SliderText extends StatefulWidget {
  const SliderText(
      {super.key,
      required this.text,
      this.height = 200,
      this.width = double.infinity,
      this.arrowTop = Icons.arrow_circle_up,
      this.arrowDown = Icons.arrow_circle_down_outlined,
      this.colorIcon = Colors.black,
      this.colorText = Colors.black,
      this.fontSize = 18,
      this.opacityViewFactor = 0.2,
      this.manificaction = 1.1,
      this.durationScrollAnim = 500,
      this.iconSize = 24,
      this.secondsAnimatedItem = 2,
      this.animated = false});

  ///List to text for scroll
  final List<String> text;

  ///[width] width to list
  final double width;

  ///[height] heigth to list
  final double height;
  final IconData arrowTop, arrowDown;
  final Color colorIcon;
  final double iconSize;
  final double fontSize;
  final Color colorText;

  ///[opacityViewFactor] min: 0.0:max:1.0,
  final double opacityViewFactor;

  ///[manificaction] min: 1.0 > aument zoom
  final double manificaction;

  ///[durationScrollAnim]duration scroll next or
  ///previus page anim
  final int durationScrollAnim;

  ///[animated] animate to next or previos
  ///item automatically
  final bool animated;

  ///[secondsAnimatedItem] time to delayed next item
  final int secondsAnimatedItem;

  @override
  State<SliderText> createState() => _SliderTextState();
}

class _SliderTextState extends State<SliderText> {
  final FixedExtentScrollController scrollController =
      FixedExtentScrollController();

  int currentIndex = 0;

  Timer? animteTimer;

  bool reverse = false;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      animatedItems();
    }
  }

  void animatedItems() {
    if (animteTimer?.isActive ?? false) animteTimer?.cancel();
    animteTimer =
        Timer.periodic(Duration(seconds: widget.secondsAnimatedItem), (t) {
      if (reverse) {
        if (currentIndex >= 1) {
          currentIndex--;
        }
        if (currentIndex >= 0) {
          scrollController.animateToItem(currentIndex,
              duration: Duration(
                milliseconds: widget.durationScrollAnim,
              ),
              curve: Curves.linear);
        }
        if (currentIndex == 0) {
          reverse = false;
        }
      } else {
        if (currentIndex < widget.text.length) {
          currentIndex++;
        }
        if (currentIndex < widget.text.length - 1) {
          scrollController.animateToItem(currentIndex,
              duration: Duration(
                milliseconds: widget.durationScrollAnim,
              ),
              curve: Curves.linear);
        }
        if (currentIndex == widget.text.length) {
          reverse = true;
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    animteTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (currentIndex > 0) {
              currentIndex--;
              scrollController.animateToItem(currentIndex,
                  duration: Duration(
                    milliseconds: widget.durationScrollAnim,
                  ),
                  curve: Curves.linear);
            }
          },
          child: Icon(
            widget.arrowTop,
            color: widget.colorIcon,
            size: widget.iconSize,
          ),
        ),
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: ListWheelScrollView.useDelegate(
            controller: scrollController,
            useMagnifier: true,
            magnification: widget.manificaction,
            overAndUnderCenterOpacity: widget.opacityViewFactor,
            physics: const FixedExtentScrollPhysics(),
            itemExtent: widget.height / widget.text.length,
            squeeze: 1.3,
            childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.text.length,
                builder: (c, index) {
                  final text = widget.text[index];
                  return Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  );
                }),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (currentIndex < widget.text.length - 1) {
              currentIndex++;
              scrollController.animateToItem(currentIndex,
                  duration: Duration(
                    milliseconds: widget.durationScrollAnim,
                  ),
                  curve: Curves.linear);
            }
          },
          child: Icon(
            widget.arrowDown,
            color: widget.colorIcon,
            size: widget.iconSize,
          ),
        ),
      ],
    );
  }
}
