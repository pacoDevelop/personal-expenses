import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guide_flutter/library/string_extension.dart';
import 'package:guide_flutter/models/transaction.dart';
import 'package:guide_flutter/widgets/chart_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        var trans = recentTransactions[i];
        if (trans.date.day == weekDay.day &&
            trans.date.month == weekDay.month &&
            trans.date.year == weekDay.year) {
          totalSum += trans.amount;
        }
      }
      return {
        'day': DateFormat.E("es_ES").format(weekDay).capitalize(),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  Chart(this.recentTransactions, {Key? key, required}) : super(key: key) {
    initializeDateFormatting("es_ES", null);
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0,
        (previousValue, element) =>
            (previousValue + (element['amount'] as double)));
  }

  double spending(e) {
    double result = (e['amount'] as double) / totalSpending;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues
              .map(
                (e) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                        label: e["day"].toString(),
                        spendingAmount: (e['amount'] as double),
                        spendingPcOfTotal:
                            totalSpending == 0.0 ? 0 : spending(e))),
              )
              .toList(),
        ),
      ),
    );
  }
}
