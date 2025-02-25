import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/widget/category/category_widget.dart';
import 'package:money_manager_3/widget/common/color_selection.dart';
import 'package:money_manager_3/widget/input/text-input.dart';

class CreateCategory extends StatefulWidget {
  final TransactionType transactionType;

  const CreateCategory({
    required this.transactionType
  });
  
  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final _formKey = GlobalKey<FormState>();
  IconData _selectedIcon = defaultCategoryIcon;
  Color _selectedColor = defaultCategoryColor;
  String? _categoryName;
  double _limitValue = 0.0;
  CategoryLimitType _limitType = CategoryLimitType.value;
  List<Color> colorList = colorMap.values.toList();
  List<IconData> iconList = iconMap.values.toList();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

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
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppConfig.paddingXLarge),
                child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    renderTopSection(),
                    renderNameInput(),
                    renderIconSection(),
                    renderColorSelection(),
                    renderLimitInput(),
                    renderCreateButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderTopSection() {
    return Center(
      child: Column(
        children: [
          CategoryWidget(
            icon: _selectedIcon,
            text: _categoryName ?? 'Category Name',
            isSelected: true,
            iconColor: _selectedColor,
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        ],
      ),
    );
  }

  Widget renderNameInput() {
    return TextInput(
      inputController: _nameController,
      label: 'Category Name',
      onChange: (value) {
        setState(() {
          _categoryName = value;
        });
      },
    );
  }

  Widget renderIconSection() {
    return Padding(
      padding: EdgeInsets.only(top: AppConfig.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Icon', style: AppConfig.fontStyle,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Scrollbar(
              thumbVisibility: true,
              radius: Radius.circular(AppConfig.borderRadius),
              child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                    children: [
                      for (IconData icon in iconList)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIcon == icon ? AppConfig.buttonSelectedColor : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                            ),
                            padding: EdgeInsets.zero
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppConfig.paddingXLarge),
                            child: Icon(
                              icon, 
                              color: AppConfig.iconColor, 
                              size: AppConfig.iconSize,
                            ),
                          ),
                        onPressed: () {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderColorSelection() {
    return ColorSelection(
      onColorSelected: onColorSelected,
      selectedColor: _selectedColor,
    );
  }

  Widget renderLimitInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(top: AppConfig.padding),
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(10, 55),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
              ),
              onPressed: () {
                setState(() {
                  _limitType = _limitType == CategoryLimitType.value ? CategoryLimitType.percentage : CategoryLimitType.value;
                });
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(capitalizeFirstLetter(_limitType.displayName), style: AppConfig.fontStyle),
                  Icon(Icons.unfold_more_sharp, color: AppConfig.iconColor),
                ],
              ),
            )
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: AppConfig.padding),
            child: TextInput(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }

                final number = num.tryParse(value);
                if (number == null) {
                  return 'Please enter a valid number';
                }

                if (_limitType == CategoryLimitType.percentage && (number < 0 || number > 100)) {
                  return 'The percentage must be between 0 and 100';
                }

                if (_limitType == CategoryLimitType.value && number < 0) {
                  return 'The value must be greater than 0';
                }

                return null;
              },
              inputController: _limitController,
              label: 'Limit',
              inputType: TextInputType.number,
              onChange: (value) {
                setState(() {
                  _limitValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget renderCreateButton() {
    return Container(
      padding: EdgeInsets.only(top: AppConfig.padding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: Size(200, 50),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            SharedService.instance.createCategory(
              _categoryName!,
              _selectedIcon,
              _selectedColor,
              widget.transactionType,
              CategoryLimitDTO(type: _limitType, limit: _limitValue));
            Navigator.pop(context);
          }
        },
        child: Text('Create', style: AppConfig.fontStyle,),
      ),
    );
  }

  void onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }
}