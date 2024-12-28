import 'package:flutter/material.dart';

class LikeAnimatedIconWidget extends StatefulWidget {
  const LikeAnimatedIconWidget({super.key});

  @override
  State<LikeAnimatedIconWidget> createState() => _LikeAnimatedIconWidgetState();
}

class _LikeAnimatedIconWidgetState extends State<LikeAnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  bool isSelected = false;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: isSelected
            ? const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              )
            : const Icon(Icons.favorite_outline_sharp));
  }
}
