import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  const TransactionList(this.transactions, this.deleteTx, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(children: <Widget>[
                Text("Sin transacciones",
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ]);
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: FittedBox(
                              child: Text('\$${transactions[index].amount}'),
                            ),
                          ),
                        ),
                        title: Text(transactions[index].title,
                            style: Theme.of(context).textTheme.headline6),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(transactions[index].date),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: mediaQuery.size.width > 460
                            ? TextButton.icon(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    deleteTx(transactions[index].id.toString()),
                                label: const Text("Eliminar"),
                                style: TextButton.styleFrom(
                                  primary: Theme.of(context).errorColor,
                                ),
                              )
                            : IconButton(
                                onPressed: () =>
                                    deleteTx(transactions[index].id.toString()),
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
              },
              itemCount: transactions.length,
            ),
    );
  }
}
