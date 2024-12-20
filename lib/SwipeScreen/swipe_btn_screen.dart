import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeActionButtons extends StatelessWidget {
  final ValueNotifier<bool> isLiked;
  final ValueNotifier<bool> isNoped;
  final MatchEngine matchItem;

  const SwipeActionButtons({
    super.key,
    required this.isLiked,
    required this.isNoped,
    required this.matchItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isNoped,
            builder: (context, isNopedValue, child) {
              return AnimatedScale(
                scale: isNopedValue ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    iconSize: 30,
                    onPressed: () {
                      matchItem.currentItem?.nope();
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 30),
          ValueListenableBuilder<bool>(
            valueListenable: isLiked,
            builder: (context, isLikedValue, child) {
              return AnimatedScale(
                scale: isLikedValue ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    iconSize: 30,
                    onPressed: () {
                      matchItem.currentItem?.like();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
