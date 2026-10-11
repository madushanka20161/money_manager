import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
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

    return Container(
      padding: EdgeInsets.only(top: AppConfig.padding),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: AppConfig.paddingSmall
            ),
            child: Text('Select Color', style: AppConfig.fontStyle,),
          ),
          Center(
            child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
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
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        style: BorderStyle.solid, 
                        width: 3, 
                        color: color
                      ),
                      color: _selectedColor == color ? color : null,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}