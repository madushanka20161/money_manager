import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

/// A custom, scrollable date-range picker.
///
/// - Tap one date to pick a single day.
/// - Tap a second date to extend it into a range. Tapping the already-picked
///   date again keeps it a single day instead of a range.
/// - The month/year dropdowns jump the scroll position straight to that
///   month instead of making the user scroll through everything in between.
///
/// [isAllTime] is owned by whoever embeds this widget (there's no "All Time"
/// checkbox in here anymore - it lives in the caller's own UI, e.g. next to
/// Cancel/Done in a dialog). When [isAllTime] is true, the calendar shows a
/// placeholder instead of the grid, and the jump dropdowns are disabled.
///
/// [backgroundColor], [selectedColor] and [fontColor] are all optional -
/// each defaults to the values this widget used before these were added,
/// so existing callers don't need to change anything.
class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialStart,
    this.initialEnd,
    required this.isAllTime,
    required this.onChanged,
    this.backgroundColor,
    this.selectedColor,
    this.fontColor,
  });

  /// Earliest selectable date.
  final DateTime firstDate;

  /// Latest selectable date.
  final DateTime lastDate;

  final DateTime? initialStart;
  final DateTime? initialEnd;

  /// Whether the caller's "All Time" option is currently selected. Purely
  /// display-driven here (hides the grid, disables the jump dropdowns) -
  /// the caller is responsible for unchecking it on their end if they want
  /// that to happen when the user taps a date via [onChanged].
  final bool isAllTime;

  /// Called whenever the user taps a date.
  final void Function(DateTime? start, DateTime? end) onChanged;

  /// Background used behind dropdown menus. Defaults to [AppConfig.popupBKColor].
  final Color? backgroundColor;

  /// Color for the selected date(s)/range and the checked "All Time" box.
  /// Defaults to [AppConfig.buttonSelectedColor].
  final Color? selectedColor;

  /// Color for all text and unselected day numbers. Defaults to [Colors.white].
  final Color? fontColor;

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  // Every month section is forced to this many grid rows regardless of how
  // many weeks it actually spans, so every item in the list below has the
  // exact same height. That fixed height is what lets _jumpTo scroll
  // straight to any month by calculated offset - jumping to a month that
  // hasn't been built yet (e.g. 20 years away) can't rely on that month
  // having a BuildContext to scroll to, since ListView.builder only builds
  // what's near the current viewport.
  static const int _gridRows = 6;
  static const double _cellHeight = 40;
  static const double _monthHeaderHeight = 28;

  late final List<DateTime> _months; // first-of-month, firstDate..lastDate
  late final ScrollController _scrollController;

  DateTime? _start;
  DateTime? _end;

  late int _jumpYear;
  late int _jumpMonth;

  Color get _backgroundColor => widget.backgroundColor ?? AppConfig.popupBKColor;
  Color get _selectedColor => widget.selectedColor ?? AppConfig.buttonSelectedColor;
  Color get _fontColor => widget.fontColor ?? Colors.white;

  double get _monthItemHeight =>
      _monthHeaderHeight +
      AppConfig.paddingSmall +
      (_gridRows * _cellHeight) +
      (AppConfig.padding * 2);

  @override
  void initState() {
    super.initState();

    _start = widget.initialStart;
    _end = widget.initialEnd;

    _months = _buildMonthList(widget.firstDate, widget.lastDate);

    final anchor = _initialAnchorMonth();
    _jumpYear = anchor.year;
    _jumpMonth = anchor.month;

    final anchorIndex =
        _months.indexWhere((m) => m.year == anchor.year && m.month == anchor.month);
    final initialOffset = anchorIndex == -1 ? 0.0 : anchorIndex * _monthItemHeight;

    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  /// Which month the calendar should open scrolled to:
  /// - both start and end set -> end's month
  /// - only one of start/end set -> that month
  /// - neither set -> the current month
  ///
  /// The result is clamped into [firstDate, lastDate]. Without this, a
  /// future initialEnd (past lastDate - we can't select future dates) would
  /// land on a month that doesn't exist in _months, and silently fall back
  /// to firstDate's month instead of staying near today.
  DateTime _initialAnchorMonth() {
    final DateTime anchor;

    if (_start != null && _end != null) {
      anchor = _end!;
    } else if (_start != null) {
      anchor = _start!;
    } else if (_end != null) {
      anchor = _end!;
    } else {
      anchor = DateTime.now();
    }

    return _clampToSelectableRange(anchor);
  }

  DateTime _clampToSelectableRange(DateTime date) {
    if (date.isBefore(widget.firstDate)) return widget.firstDate;
    if (date.isAfter(widget.lastDate)) return widget.lastDate;
    return date;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _buildMonthList(DateTime first, DateTime last) {
    final months = <DateTime>[];
    var cursor = DateTime(first.year, first.month);
    final end = DateTime(last.year, last.month);

    while (!cursor.isAfter(end)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return months;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day) {
    if (_start == null || _end == null) return false;
    return !day.isBefore(_start!) && !day.isAfter(_end!);
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_start == null || _end != null) {
        // Starting a fresh selection.
        _start = day;
        _end = null;
      } else if (_isSameDay(day, _start!)) {
        // Tapped the same date again: keep it a single-day range.
        _end = _start;
      } else if (day.isBefore(_start!)) {
        _end = _start;
        _start = day;
      } else {
        _end = day;
      }
    });

    widget.onChanged(_start, _end);
  }

  /// Scrolls straight to [year]/[month] by calculated offset. Works even if
  /// that month is far outside what's currently built, because every month
  /// item has the same fixed height (_monthItemHeight) - no BuildContext for
  /// the target month is needed, unlike Scrollable.ensureVisible.
  void _jumpTo(int year, int month) {
    final index = _months.indexWhere((m) => m.year == year && m.month == month);
    if (index == -1) return;

    setState(() {
      _jumpYear = year;
      _jumpMonth = month;
    });

    if (!_scrollController.hasClients) return;

    final target = (index * _monthItemHeight).clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String get _displayText {
    if (widget.isAllTime) return 'All Time';
    if (_start == null) return 'Select a date';
    if (_end == null || _isSameDay(_start!, _end!)) {
      return _formatDate(_start!);
    }
    return '${_formatDate(_start!)}  to  ${_formatDate(_end!)}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppConfig.paddingSmall),
          child: Text(
            _displayText,
            style: AppConfig.fontStyle.copyWith(
              color: _fontColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildJumpControls(),
        SizedBox(height: AppConfig.paddingSmall),
        _buildWeekdayHeader(),
        Expanded(
          child: widget.isAllTime
              ? Center(
                  child: Text(
                    'Showing all transactions',
                    style: TextStyle(color: _fontColor.withOpacity(0.6)),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _months.length,
                  itemExtent: _monthItemHeight,
                  itemBuilder: (context, index) {
                    return _MonthSection(
                      month: _months[index],
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      start: _start,
                      end: _end,
                      onDayTap: _onDayTap,
                      isSameDay: _isSameDay,
                      isInRange: _isInRange,
                      gridRows: _gridRows,
                      cellHeight: _cellHeight,
                      headerHeight: _monthHeaderHeight,
                      selectedColor: _selectedColor,
                      fontColor: _fontColor,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildJumpControls() {
    final years = [for (var y = widget.firstDate.year; y <= widget.lastDate.year; y++) y];
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return Opacity(
      opacity: widget.isAllTime ? 0.4 : 1,
      child: IgnorePointer(
        ignoring: widget.isAllTime,
        child: Row(
          children: [
            Expanded(
              child: DropdownButton<int>(
                value: _jumpMonth,
                dropdownColor: _backgroundColor,
                isExpanded: true,
                style: TextStyle(color: _fontColor),
                underline: const SizedBox.shrink(),
                items: [
                  for (var m = 1; m <= 12; m++)
                    DropdownMenuItem(value: m, child: Text(monthNames[m - 1])),
                ],
                onChanged: (month) {
                  if (month != null) _jumpTo(_jumpYear, month);
                },
              ),
            ),
            SizedBox(width: AppConfig.paddingSmall),
            Expanded(
              child: DropdownButton<int>(
                value: _jumpYear,
                dropdownColor: _backgroundColor,
                isExpanded: true,
                style: TextStyle(color: _fontColor),
                underline: const SizedBox.shrink(),
                items: [
                  for (final y in years)
                    DropdownMenuItem(value: y, child: Text(y.toString())),
                ],
                onChanged: (year) {
                  if (year != null) _jumpTo(year, _jumpMonth);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppConfig.paddingSmall),
      child: Row(
        children: [
          for (final label in labels)
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: _fontColor.withOpacity(0.6),
                    fontSize: AppConfig.fontSize * 0.8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One month's header + a fixed-size day grid (always [gridRows] rows) so
/// every item in the parent ListView has identical height.
class _MonthSection extends StatelessWidget {
  const _MonthSection({
    required this.month,
    required this.firstDate,
    required this.lastDate,
    required this.start,
    required this.end,
    required this.onDayTap,
    required this.isSameDay,
    required this.isInRange,
    required this.gridRows,
    required this.cellHeight,
    required this.headerHeight,
    required this.selectedColor,
    required this.fontColor,
  });

  final DateTime month;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? start;
  final DateTime? end;
  final void Function(DateTime day) onDayTap;
  final bool Function(DateTime a, DateTime b) isSameDay;
  final bool Function(DateTime day) isInRange;
  final int gridRows;
  final double cellHeight;
  final double headerHeight;
  final Color selectedColor;
  final Color fontColor;

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Monday-first grid: DateTime.weekday is 1 (Mon) .. 7 (Sun).
    final leadingBlanks = DateTime(month.year, month.month, 1).weekday - 1;
    final totalCells = gridRows * 7;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppConfig.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: headerHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_monthNames[month.month - 1]} ${month.year}',
                style: AppConfig.fontStyle.copyWith(
                  color: fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: AppConfig.paddingSmall),
          SizedBox(
            height: gridRows * cellHeight,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: cellHeight,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final dayNumber = index - leadingBlanks + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox.shrink();
                }

                final day = DateTime(month.year, month.month, dayNumber);
                final isSelectable =
                    !day.isBefore(firstDate) && !day.isAfter(lastDate);
                final isStart = start != null && isSameDay(day, start!);
                final isEnd = end != null && isSameDay(day, end!);

                return _DayCell(
                  day: day,
                  isSelectable: isSelectable,
                  isStart: isStart,
                  isEnd: isEnd,
                  isInRange: isInRange(day),
                  onTap: isSelectable ? () => onDayTap(day) : null,
                  selectedColor: selectedColor,
                  fontColor: fontColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelectable,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.onTap,
    required this.selectedColor,
    required this.fontColor,
  });

  final DateTime day;
  final bool isSelectable;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final VoidCallback? onTap;
  final Color selectedColor;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    // Gate the highlight on isSelectable too, not just isStart/isEnd/
    // isInRange: an initialStart/initialEnd outside [firstDate, lastDate]
    // (e.g. a future end date) must never render as picked, even though it
    // still equals _start/_end internally - only what's actually selectable
    // should ever look selected.
    final isEndpoint = isSelectable && (isStart || isEnd);
    final isHighlightedRange = isSelectable && isInRange;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isEndpoint
                  ? selectedColor
                  : isHighlightedRange
                      ? selectedColor.withOpacity(0.3)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: isSelectable ? fontColor : fontColor.withOpacity(0.24),
                fontWeight: isEndpoint ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}