import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/index.dart';

class ColorSelection extends StatefulWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  ColorSelection({
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  _ColorSelectionState createState() => _ColorSelectionState();
}

class _ColorSelectionState extends State<ColorSelection> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();

    _selectedColor = widget.selectedColor ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorList = colorMap.values.toList();

    return Column(
        children: [
          Text('Select Color'),
          Wrap(
            spacing: 10.0,
            children: [
              for (Color color in colorList)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });

                    widget.onColorSelected(color);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: _selectedColor == color ? Border.all(style: BorderStyle.solid, width: 5) : null,
                      color: color
                    ),
                  ),
                ),
            ],
          ),
        ],
    );
  }
}