import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final Function(int) onSelect;
  const ToggleButton({
    super.key,
    required this.onSelect,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool showFavarite = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(8),
        isSelected: [!showFavarite, showFavarite],
        children: [Icon(Icons.list), Icon(Icons.favorite)],
        onPressed: (i) {
          widget.onSelect(i);
          setState(() {
            showFavarite = i == 1;
          });
        },
      ),
    );
  }
}
