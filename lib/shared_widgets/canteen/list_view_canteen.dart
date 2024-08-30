import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/local_imports.dart';
import 'package:autojidelna/shared_widgets/canteen/day_card.dart';
import 'package:autojidelna/shared_widgets/canteen/error_loading_data.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListViewCanteen extends StatelessWidget {
  const ListViewCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<Jidelnicek>> fetchDailyMenus() async {
      const int daysToFetch = 20; // Number of days to be fetched
      final List<Jidelnicek> dailyMenus = [];

      for (int i = 0; i < daysToFetch; i++) {
        final jidelnicek = await loggedInCanteen.getLunchesForDay(convertIndexToDatetime(pageviewController.initialPage + i));
        dailyMenus.add(jidelnicek);
      }

      return dailyMenus;
    }

    return FutureBuilder<List<Jidelnicek>>(
      future: fetchDailyMenus(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(lang.errorsLoadingData));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final dailyMenus = snapshot.data ?? [];

        if (dailyMenus.isEmpty) return const ErrorLoadingData();

        return ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemCount: dailyMenus.length,
          itemBuilder: (context, index) => DayCard(jidelnicek: dailyMenus[index]),
        );
      },
    );
  }
}
