import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/methods_vars/get_correct_date_string.dart';
import 'package:autojidelna/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool disabled = context.watch<AppearancePreferences>().isListUi;
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: disabled ? null : () => showCustomDatePicker(context, dateListener.value),
        icon: const Icon(Icons.calendar_month_outlined),
        label: Selector<AppearancePreferences, DateFormatOptions>(
          selector: (_, p1) => p1.dateFormat,
          builder: (context, dateFormat, _) => ValueListenableBuilder(
            valueListenable: dateListener,
            builder: (context, value, ___) => Text(getCorrectDateString(dateFormat, date: value)),
          ),
        ),
      ),
    );
  }
}

class TodayButton extends StatelessWidget {
  const TodayButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool disabled = context.watch<AppearancePreferences>().isListUi;
    return SizedBox(
      width: 35,
      height: 35,
      child: MaterialButton(
        textColor: Theme.of(context).colorScheme.onSurfaceVariant,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant, width: 1.75),
        ),
        onPressed: disabled ? null : () => changeDate(newDate: DateTime.now(), animateToPage: true),
        child: Text(DateTime.now().day.toString()),
      ),
    );
  }
}
