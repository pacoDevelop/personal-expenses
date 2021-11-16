import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPcOfTotal;

  const ChartBar(
      {required this.label,
      required this.spendingAmount,
      required this.spendingPcOfTotal,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctc, constraint) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: constraint.maxHeight * 0.15,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(height: constraint.maxHeight * 0.05),
          SizedBox(
            height: constraint.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    // color: const Color.fromRGBO(220, 220, 220, 1),
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 1 - spendingPcOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          SizedBox(height: constraint.maxHeight * 0.15, child: Text(label))
        ],
      );
    });
  }
}
