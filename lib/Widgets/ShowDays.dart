import 'package:day_picker/model/day_in_week.dart';
import 'package:flutter/material.dart';

class ShowDays extends StatefulWidget {
  /// List of days of type `DayInWeek`
  final List<DayInWeek> days;

  /// [backgroundColor] - property to change the color of the container.
  final Color? backgroundColor;

  /// [fontWeight] - property to change the weight of selected text
  final FontWeight? fontWeight;

  /// [fontSize] - property to change the size of selected text
  final double? fontSize;

  /// [daysFillColor] -  property to change the button color of days when the button is pressed.
  final Color? daysFillColor;

  /// [daysBorderColor] - property to change the border color of the rounded buttons.
  final Color? daysBorderColor;

  /// [selectedDayTextColor] - property to change the color of text when the day is selected.
  final Color? selectedDayTextColor;

  /// [unSelectedDayTextColor] - property to change the text color when the day is not selected.
  final Color? unSelectedDayTextColor;

  /// [border] Boolean to handle the day button border by default the border will be true.
  final bool border;

  /// [boxDecoration] to handle the decoration of the container.
  final BoxDecoration? boxDecoration;

  /// [padding] property  to handle the padding between the container and buttons by default it is 8.0
  final double padding;

  /// The property that can be used to specify the [width] of the [ShowDays] container.
  /// By default this property will take the full width of the screen.
  final double? width;

  /// `ShowDays` takes a list of days of type `DayInWeek`.
  ShowDays({
    this.backgroundColor,
    this.fontWeight,
    this.fontSize,
    this.daysFillColor,
    this.daysBorderColor,
    this.selectedDayTextColor,
    this.unSelectedDayTextColor,
    this.border = true,
    this.boxDecoration,
    this.padding = 8.0,
    this.width,
    required this.days,
    super.key,
  });

  @override
  ShowDaysState createState() => ShowDaysState(days);
}

class ShowDaysState extends State<ShowDays> {
  ShowDaysState(List<DayInWeek> days) : _daysInWeek = days;

  // list to insert the selected days.
  List<String> selectedDays = [];

  // list of days in a week.
  List<DayInWeek> _daysInWeek = [];

  @override
  void initState() {
    _daysInWeek.forEach((element) {
      if (element.isSelected) {
        selectedDays.add(element.dayKey);
      }
    });
    super.initState();
  }

  /// Set days to new value
  void setDaysState(List<DayInWeek> newDays) {
    selectedDays = [];
    for (DayInWeek dayInWeek in newDays) {
      if (dayInWeek.isSelected) {
        selectedDays.add(dayInWeek.dayKey);
      }
    }
    setState(() {
      _daysInWeek = newDays;
    });
  }

  void _getSelectedWeekDays(bool isSelected, String day) {
    if (isSelected == true) {
      if (!selectedDays.contains(day)) {
        selectedDays.add(day);
      }
    } else if (isSelected == false) {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      }
    }
    // [onSelect] is the callback which passes the Selected days as list.
  }

// getter to handle background color of container.
  Color? get _handleBackgroundColor {
    if (widget.backgroundColor == null) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return widget.backgroundColor;
    }
  }

// getter to handle fill color of buttons.
  Color? get _handleDaysFillColor {
    if (widget.daysFillColor == null) {
      return Colors.white;
    } else {
      return widget.daysFillColor;
    }
  }

//getter to handle border color of days[buttons].
  Color? get _handleBorderColorOfDays {
    if (widget.daysBorderColor == null) {
      return Colors.white;
    } else {
      return widget.daysBorderColor;
    }
  }

// Handler to change the text color when the button is pressed and not pressed.
  Color? _handleTextColor(bool onSelect) {
    Color? textColor = Colors.black;
    if (onSelect == true) {
      if (widget.selectedDayTextColor == null) {
        textColor = Colors.black;
      } else {
        textColor = widget.selectedDayTextColor;
      }
    } else if (onSelect == false) {
      if (widget.unSelectedDayTextColor == null) {
        textColor = Colors.white;
      } else {
        textColor = widget.unSelectedDayTextColor;
      }
    }
    return textColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: widget.boxDecoration == null
          ? BoxDecoration(
              color: _handleBackgroundColor,
              borderRadius: BorderRadius.circular(0),
            )
          : widget.boxDecoration,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _daysInWeek.map(
            (day) {
              return Expanded(
                child: RawMaterialButton(
                  fillColor: day.isSelected ? _handleDaysFillColor : null,
                  shape: CircleBorder(
                    side: widget.border
                        ? BorderSide(
                            color: _handleBorderColorOfDays!,
                            width: 2.0,
                          )
                        : BorderSide.none,
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      day.dayName.length < 3
                          ? day.dayName
                          : day.dayName.substring(0, 3),
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: widget.fontWeight,
                        color: _handleTextColor(day.isSelected),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
