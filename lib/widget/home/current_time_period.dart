import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:provider/provider.dart';

class CurrentTimePeriod extends StatefulWidget {
  @override
  _CurrentTimePeriodState createState() => _CurrentTimePeriodState();
}

class _CurrentTimePeriodState extends State<CurrentTimePeriod> {
  String displayText = '';
  late DateTime startDate;
  late DateTime endDate;
  late String timePeriod;
  late AppState appState;
  late UserState userState;
  bool disableSwipeLeft = false;
  bool disableSwipeRight = false;

  @override
  void initState() {
    super.initState();
    timePeriod = UserStateService.instance.defaultTimePeriod!;
    setDateRangeForPeriod();
    updateDisplayText();
    updateSwipeState();
  }

  void updateSwipeState() {
    DateTime today = DateTime.now();

    switch (timePeriod) {
      case 'custom':
        setState(() {
          disableSwipeLeft = true;
          disableSwipeRight = true;
        });
        
        break;
      default:
        if (today == startDate || today.isAfter(startDate) && today.isBefore(endDate)) {
          setState(() {
            disableSwipeRight = true;
          });
        } else {
          setState(() {
            disableSwipeRight = false;
          });
        }

        setState(() {
          disableSwipeLeft = false;
        });
        break;
    }
  }

  void setDateRangeForPeriod() {
    List<DateTime> dateRange;

    try {
      dateRange = getDateRange(timePeriod, appState);
    } catch (e) {
      dateRange = getDateRange(timePeriod, null);
    }
    
    startDate = dateRange[0];
    endDate = dateRange[1];
  }

  void updateDisplayText() {
    String text = '';
    
    switch (timePeriod) {
      case 'day':
        text = '${startDate.day} ${DateFormat('MMMM').format(startDate)} ${startDate.year}';
        break;
      case 'week':
        text = '${startDate.day} ${DateFormat('MMMM').format(startDate)} - ${endDate.day} ${DateFormat('MMMM').format(endDate)}';
        break;
      case 'month':
        text = '${DateFormat('MMMM').format(startDate)} ${startDate.year}';
        break;
      case 'year':
        text = '${startDate.year}';
        break;
      default:
        text = 'Custom';
    }

    setState(() {
      displayText = text;
    });
  }

  void updateTimes(String direction) {
    int multiplier = direction == 'left' ? -1 : 1;

    void updateDay() {
      startDate = startDate.add(Duration(days: multiplier));
      endDate = endDate.add(Duration(days: multiplier));
    }

    void updateWeek() {
      startDate = startDate.add(Duration(days: 7 * multiplier));
      endDate = endDate.add(Duration(days: 7 * multiplier));
    }

    void updateMonth() {
      startDate = DateTime(startDate.year, startDate.month + multiplier, 1, 0, 0, 0);
      endDate = DateTime(startDate.year, startDate.month + 1, 0, 23, 59, 59);
    }

    void updateYear() {
      startDate = DateTime(startDate.year + multiplier, 1, 1, 0, 0, 0);
      endDate = DateTime(startDate.year + multiplier, 12, 31, 23, 59, 59);
    }

    switch (timePeriod) {
      case 'day':
        updateDay();
        break;
      case 'week':
        updateWeek();
        break;
      case 'month':
        updateMonth();
        break;
      case 'year':
        updateYear();
        break;
      default:
        throw Exception('[CurrentTimePeriod] Invalid period');
    }

    appState.setDateRange(startDate, endDate);
    
    updateDisplayText();
  }

  void _onSwipeLeft() {
    if (!disableSwipeLeft) {
      updateTimes('left');
    }
  }

  void _onSwipeRight() {
    if (!disableSwipeRight) {
      updateTimes('right');
    }
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<AppState>(); 
    userState = context.watch<UserState>();
    String newTimePeriod = userState.selectedTimePeriod ?? userState.defaultTimePeriod!;

    if (newTimePeriod != timePeriod) {
      timePeriod = newTimePeriod;
      setDateRangeForPeriod();
    }

    updateDisplayText();
    updateSwipeState();
    
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _onSwipeRight();
        } else if (details.primaryVelocity! < 0) {
          _onSwipeLeft();
        }
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !disableSwipeLeft ? IconButton(onPressed: _onSwipeLeft, icon: Icon(Icons.arrow_back_ios, size: 18.0, color: Colors.white)) : SizedBox(width: 48, height: 48,),
            Text(displayText, style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
            !disableSwipeRight ? IconButton(onPressed: _onSwipeRight, icon: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.white)) : SizedBox(width: 48, height: 48,),
          ],
        ),
      ),
    );
  }
}