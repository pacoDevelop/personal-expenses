import 'package:flutter/material.dart';
import 'package:guide_flutter/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTx;

  const TransactionItem(
    this.transaction,
    this.deleteTx, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text('\$${transaction.amount}'),
                ),
              ),
            ),
            title: Text(transaction.title,
                style: Theme.of(context).textTheme.headline6),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(transaction.date),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: MediaQuery.of(context).size.width > 460
                ? TextButton.icon(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteTx(transaction.id),
                    label: const Text("Eliminar"),
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).errorColor,
                    ),
                  )
                : IconButton(
                    onPressed: () => deleteTx(transaction.id),
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor),
          ),
        ),
        Divider(
          height: 1,
          thickness: 3,
          indent: 5,
          endIndent: 5,
          color: Theme.of(context).primaryColorLight,
        ),
      ],
    );
  }
}
