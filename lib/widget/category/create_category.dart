import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/widget/category/category_widget.dart';

class CreateCategory extends StatefulWidget {
  final TransactionType transactionType;

  const CreateCategory({
    required this.transactionType
  });
  
  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  IconData? _selectedIcon;
  Color? _selectedColor;
  String? _categoryName;
  List<Color> colorList = colorMap.values.toList();
  List<IconData> iconList = iconMap.values.toList();
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedColor = colorList[0];
    _selectedIcon = iconList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
      ),
      body: Column(
        children: [
          renderTopSection(),
          renderIconSection(),
          renderColorSelection(),
          renderCreateButton(),
        ],
      ),
    );
  }

  Widget renderTopSection() {
    return Container(
      child: Column(
        children: [
          if (_selectedIcon != null)
            CategoryWidget(
              icon: _selectedIcon!,
              text: _categoryName ?? '',
              isSelected: true,
              iconColor: _selectedColor?? Colors.blue,
            ),
          TextField(
            controller: _categoryNameController,
            decoration: InputDecoration(labelText: 'Category Name'),
            onChanged: (value) {
              setState(() {
                _categoryName = value;
              });
            },
          ),
        ],
      )
    );
  }

  Widget renderIconSection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          Text('Select Icon'),
          Wrap(
            spacing: 10.0,
            children: [
              for (IconData icon in iconList)
                IconButton(
                  icon: Icon(icon),
                  onPressed: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget renderColorSelection() {
    return Container(
      height: 200,
      child: Column(
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
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: color,
                  ),
                ),
            ],
          ),
        ],
      )
    );
  }

  Widget renderCreateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: (_categoryName ?? '').isNotEmpty
            ? () {
              // TODO: neeed to a input for category limit
                SharedService.instance.createCategory(
                  _categoryName!,
                  _selectedIcon!, 
                  _selectedColor!, 
                  widget.transactionType, 
                  CategoryLimitDTO(type: CategoryLimitType.value, limit: 0.0)
                );
                Navigator.pop(context);
              }
            : null,
        child: Text('Create'),
      ),
    );
  }
}