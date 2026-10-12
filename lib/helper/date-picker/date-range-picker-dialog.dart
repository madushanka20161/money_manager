import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/date-picker/date-range-picker.dart';

/// What the user confirmed when closing [showCustomDateRangePicker].
class DateRangePickerResult {
  const DateRangePickerResult({
    this.start,
    this.end,
    required this.isAllTime,
  });

  final DateTime? start;
  final DateTime? end;
  final bool isAllTime;
}

/// Shows [DateRangePicker] in a popup dialog, with the "All Time" checkbox
/// and Cancel/Done actions in one row at the bottom (checkbox on the left,
/// Cancel/Done on the right).
///
/// Returns null if the user cancels or dismisses the dialog (e.g. taps
/// outside it), otherwise a [DateRangePickerResult] with their selection.
///
/// [backgroundColor], [selectedColor] and [fontColor] are all optional -
/// each defaults to the same values the dialog used before these were
/// added, so existing callers don't need to pass anything.
Future<DateRangePickerResult?> showCustomDateRangePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? initialStart,
  DateTime? initialEnd,
  bool initialIsAllTime = false,
  Color? backgroundColor,
  Color? selectedColor,
  Color? fontColor,
}) {
  return showDialog<DateRangePickerResult>(
    context: context,
    builder: (context) => _DateRangePickerDialog(
      firstDate: firstDate,
      lastDate: lastDate,
      initialStart: initialStart,
      initialEnd: initialEnd,
      initialIsAllTime: initialIsAllTime,
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      fontColor: fontColor,
    ),
  );
}

class _DateRangePickerDialog extends StatefulWidget {
  const _DateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    this.initialStart,
    this.initialEnd,
    required this.initialIsAllTime,
    this.backgroundColor,
    this.selectedColor,
    this.fontColor,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final bool initialIsAllTime;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? fontColor;

  @override
  State<_DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<_DateRangePickerDialog> {
  // The dialog is now the single owner of this selection - DateRangePicker
  // just reports date taps via onChanged and reflects isAllTime back as a
  // read-only prop (to hide the grid / dim the jump dropdowns).
  DateTime? _start;
  DateTime? _end;
  bool _isAllTime = false;

  Color get _backgroundColor => widget.backgroundColor ?? AppConfig.popupBKColor;
  Color get _selectedColor => widget.selectedColor ?? AppConfig.buttonSelectedColor;
  Color get _fontColor => widget.fontColor ?? Colors.white;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
    _isAllTime = widget.initialIsAllTime;
  }

  void _onDateChanged(DateTime? start, DateTime? end) {
    _start = start;
    _end = end;
    // No setState needed: DateRangePicker already re-renders its own grid
    // for the tap that triggered this, and nothing else in this dialog's
    // UI depends on _start/_end until Done is pressed.
  }

  void _onAllTimeChanged(bool? checked) {
    setState(() {
      _isAllTime = checked ?? false;
      if (_isAllTime) {
        _start = null;
        _end = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08,
        vertical: 40,
      ),
      child: SizedBox(
        // Fills most of the screen height so there's real room to scroll
        // and read months, minus the dialog's own inset padding above.
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: EdgeInsets.all(AppConfig.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Date',
                style: AppConfig.fontStyle.copyWith(
                  color: _fontColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppConfig.fontSize * 1.1,
                ),
              ),
              SizedBox(height: AppConfig.paddingSmall),
              Expanded(
                child: DateRangePicker(
                  // Forces a fresh internal start/end state whenever
                  // "All Time" is toggled, so leftover highlighted dates
                  // don't linger after the grid is hidden and shown again.
                  key: ValueKey(_isAllTime),
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  initialStart: _start,
                  initialEnd: _end,
                  isAllTime: _isAllTime,
                  backgroundColor: _backgroundColor,
                  selectedColor: _selectedColor,
                  fontColor: _fontColor,
                  onChanged: _onDateChanged,
                ),
              ),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppConfig.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAllTimeCheckbox(),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: TextStyle(color: _fontColor.withOpacity(0.7))),
              ),
              SizedBox(width: AppConfig.paddingSmall),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    DateRangePickerResult(
                      start: _start,
                      end: _end,
                      isAllTime: _isAllTime,
                    ),
                  );
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: _fontColor.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllTimeCheckbox() {
    // Plain Checkbox + Text instead of CheckboxListTile: ListTile wants to
    // take the full row width, which fights with Cancel/Done sharing the
    // same row. Material(transparency) is still needed - Checkbox requires
    // a Material ancestor the same way CheckboxListTile did.
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: () => _onAllTimeChanged(!_isAllTime),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _isAllTime,
                activeColor: _selectedColor,
                onChanged: _onAllTimeChanged,
              ),
              Text('All Time', style: TextStyle(color: _fontColor)),
            ],
          ),
        ),
      ),
    );
  }
}