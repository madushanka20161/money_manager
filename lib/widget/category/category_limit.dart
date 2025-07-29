import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/popup-helper.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/widget/input/limit_input.dart';

class CategoryLimit extends StatefulWidget {
  final CategoryDTO category;

  const CategoryLimit({required this.category});

  @override
  _CategoryLimitState createState() => _CategoryLimitState();
}

class _CategoryLimitState extends State<CategoryLimit> {
  late double limitValue;
  late CategoryLimitType limitType;
  double iconHeight = 45;
  double iconWidth = 45;

  @override
  void initState() {
    limitValue = widget.category.limit.limit;
    limitType = widget.category.limit.type;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.category.iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(AppConfig.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: iconHeight,
                      height: iconWidth,
                      decoration: BoxDecoration(
                        color: widget.category.iconColor.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(widget.category.icon,
                            size: 30, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppConfig.paddingLarge),
                      child: Text(
                          widget.category.limit.limit == 0
                              ? '--'
                              : widget.category.limit.type ==
                                      CategoryLimitType.value
                                  ? '${UserStateService.instance.defaultCurrency!} : ${widget.category.limit.limit.toString()}'
                                  : '${widget.category.limit.limit.toString()} %',
                          style: AppConfig.fontStyle),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: AppConfig.paddingSmall),
                      child: Text(
                        capitalizeFirstLetter(widget.category.name),
                        style: TextStyle(
                            fontSize: AppConfig.fontSize,
                            color: AppConfig.fontColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [          
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,
                        size: AppConfig.iconSize * 0.8,
                        color: AppConfig.iconColor),
                    onPressed: () {
                      PopupHelper.showPopup(context, [editLimit()]);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.clear,
                        size: AppConfig.iconSize * 0.8,
                        color: AppConfig.iconColor),
                    onPressed: () {
                      deleteLimit();
                    },
                  ),
                ]
              ),
            ],
          ),
        ],
      ),
      // child: Row(
      //   children: [
      //     Expanded(
      //       flex: 1,
      //       child: Column(
      //         children: [
      //           Container(
      //             width: iconHeight,
      //             height: iconWidth,
      //             decoration: BoxDecoration(
      //               color: widget.category.iconColor.withOpacity(0.6),
      //               shape: BoxShape.circle,
      //             ),
      //             child: Center(
      //               child: Icon(widget.category.icon,
      //                   size: 30, color: Colors.white),
      //             ),
      //           ),
      //           Container(
      //             padding: EdgeInsets.only(top: AppConfig.paddingSmall),
      //             child: Text(
      //               widget.category.name,
      //               style: TextStyle(
      //                   fontSize: AppConfig.fontSize,
      //                   color: AppConfig.fontColor),
      //               overflow: TextOverflow.ellipsis,
      //               maxLines: 1,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Expanded(
      //       flex: 3,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //               widget.category.limit.limit == 0
      //                   ? '--'
      //                   : widget.category.limit.type == CategoryLimitType.value
      //                       ? '$defaultCurrency : ${widget.category.limit.limit.toString()}'
      //                       : '${widget.category.limit.limit.toString()} %',
      //               style: AppConfig.fontStyle),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               IconButton(
      //                 icon: Icon(Icons.edit,
      //                     size: AppConfig.iconSize * 0.8,
      //                     color: AppConfig.iconColor),
      //                 onPressed: () {
      //                   PopupHelper.showPopup(context, [editLimit()]);
      //                 },
      //               ),
      //               IconButton(
      //                 icon: Icon(Icons.clear,
      //                     size: AppConfig.iconSize * 0.8,
      //                     color: AppConfig.iconColor),
      //                 onPressed: () {
      //                   deleteLimit();
      //                 },
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  void deleteLimit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConfig.popupBKColor,
          title: Text('Remove Limit', style: TextStyle(color: AppConfig.fontColor),),
          content: Text('Are you sure you want to remove this limit?', style: AppConfig.fontStyle,),
          actions: [
            TextButton(
              child: Text('Cancel', style: AppConfig.fontStyle,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: AppConfig.fontStyle,),
              onPressed: () {
                SharedService.instance.updateCategoryLimit(
                    widget.category.id, widget.category.limit.type, 0);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget editLimit() {
    return Column(
      children: [
        LimitInput(
            limitType: widget.category.limit.type,
            limitValue: widget.category.limit.limit,
            onTypeChange: (CategoryLimitType type) {
              setState(() {
                limitType = type;
              });
            },
            onValueChange: (value) {
              setState(() {
                limitValue = value;
              });
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text('Cancel', style: AppConfig.fontStyle,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update', style: AppConfig.fontStyle,),
              onPressed: () {
                SharedService.instance.updateCategoryLimit(
                    widget.category.id, limitType, limitValue);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
