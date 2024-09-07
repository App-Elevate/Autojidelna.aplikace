import 'package:autojidelna/classes_enums/all.dart';
import 'package:autojidelna/methods_vars/datetime_wrapper.dart';
import 'package:autojidelna/methods_vars/ordering.dart';
import 'package:autojidelna/pages_new/dish_detail.dart';
import 'package:autojidelna/providers.dart';
import 'package:canteenlib/canteenlib.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FoodSectionListTile extends StatelessWidget {
  const FoodSectionListTile({super.key, required this.title, required this.selection});
  final String title;
  final List<Jidlo> selection;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: timeOfDayFoodTitle(context, title),
      subtitle: Column(
        children: selection.asMap().entries.map((data) {
          int index = data.key;
          Jidlo dish = data.value;

          String title = (selection[index].kategorizovano?.hlavniJidlo ?? selection[index].nazev) == ''
              ? selection[index].nazev
              : (selection[index].kategorizovano?.hlavniJidlo ?? selection[index].nazev);

          return _DishListTile(dish: dish, title: title);
        }).toList(),
      ),
    );
  }

  Text timeOfDayFoodTitle(BuildContext context, String text) => Text(text.toUpperCase(), style: Theme.of(context).textTheme.titleSmall);
}

class _DishListTile extends StatelessWidget {
  const _DishListTile({required this.dish, required this.title});
  final Jidlo dish;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<DishesOfTheDay>(
      builder: (context, data, ___) {
        Jidelnicek? menu = data.getMenu(convertDateTimeToIndex(dish.den));
        Jidlo updatedDish = menu!.jidla.where((e) => e.nazev == dish.nazev).first;
        StavJidla stav = getStavJidla(updatedDish);

        return Consumer<Ordering>(
          builder: (context, prov, ___) => ListTile(
            enabled: !prov.ordering && (updatedDish.lzeObjednat || updatedDish.objednano),
            selected: getPrimaryState(stav),
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
            leading: Radio<bool>(
              toggleable: true,
              value: getPrimaryState(stav),
              groupValue: true,
              onChanged: prov.ordering || !isButtonEnabled(stav) ? null : (_) => pressed(context, updatedDish, stav),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            title: Text(title),
            subtitle: updatedDish.cena == null
                ? null
                : Text(NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toLanguageTag()).format(updatedDish.cena)),
            trailing: _detailButton(context),
          ),
        );
      },
    );
  }

  IconButton _detailButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DishDetail(dish: dish))),
      icon: Icon(
        Icons.info_outline,
        color: Theme.of(context).listTileTheme.subtitleTextStyle!.color,
        size: 24,
      ),
    );
  }
}
