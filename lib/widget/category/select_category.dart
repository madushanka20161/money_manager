import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/category/category_widget.dart';
import 'package:money_manager_3/widget/category/create_category.dart';
import 'package:provider/provider.dart';

class SelectCategory extends StatefulWidget {
  final String? categoryId;
  final Function onCategorySelected;
  final TransactionType transactionType;

  SelectCategory({
    required this.categoryId,
    required this.onCategorySelected,
    required this.transactionType
  });

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  Map<String, CategoryDTO> categories = {};

  @override
  Widget build(BuildContext context) {
    categories = context.watch<AppState>().categories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          Padding(
            padding: EdgeInsets.all(AppConfig.padding),
            child: Column(
              children: [
                Center(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.spaceAround,
                    children: renderCategoryList(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppConfig.padding),
                  child: ElevatedButton(
                    style: AppConfig.elevatedButtonStyle,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateCategory(transactionType: widget.transactionType),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConfig.paddingXLarge * 2,
                        vertical: AppConfig.paddingLarge
                      ), 
                      child: Text('Create Category', style: AppConfig.fontStyle,)
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

  List<Widget> renderCategoryList(BuildContext context) {
    double categoryButtonWidth = (MediaQuery.of(context).size.width - AppConfig.padding * 2 - 10*3) / 4;
    double categoryButtonHeight = 80;
    List<CategoryDTO> categoryList = categories.values.where((CategoryDTO category) => category.type == widget.transactionType).toList();
    List<Widget> widgetList = [];
    
    for (CategoryDTO category in categoryList) {
      widgetList.add(
        ElevatedButton(
          onPressed: () {
            widget.onCategorySelected(category.id);
          },
          style: AppConfig.elevatedButtonStyle,
          child: CategoryWidget(
            width: categoryButtonWidth,
            height: categoryButtonHeight,
            icon: category.icon, 
            text: category.name,
            isSelected: widget.categoryId == category.id,
            iconColor: category.iconColor,
            iconColorOpacity: 0.8,
            fontSize: AppConfig.fontSize,
          )
        ),
      );
    }

    return widgetList;
  }
}