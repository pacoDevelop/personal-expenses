import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guide_flutter/library/hex_color.dart';
import 'package:guide_flutter/widgets/chart.dart';
import 'package:guide_flutter/widgets/transaction_list.dart';
import 'package:universal_platform/universal_platform.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';

void main() {
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

// const title = "Personal Expenses";
const title = "Gastos personales";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          accentColor: Colors.amberAccent,
          errorColor: HexColor('#840606'),
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                button: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
          appBarTheme: AppBarTheme(
              titleTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                      headline6: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 20,
                          fontWeight: FontWeight.bold))
                  .headline6,
              toolbarTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                      headline6: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 20,
                          fontWeight: FontWeight.bold))
                  .bodyText2)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Zapatos',
      amount: 69.99,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 't2',
      title: 'Camisa',
      amount: 16.53,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 't3',
      title: 'Zapatillas',
      amount: 29.99,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 't4',
      title: 'Reloj',
      amount: 36.53,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((e) {
      return e.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: date,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {
            debugPrint("tap");
          },
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var isLandscape = !(UniversalPlatform.isDesktop || UniversalPlatform.isWeb);
    if (isLandscape) {
      isLandscape = mediaQuery.orientation == Orientation.landscape;
    }

    final PreferredSizeWidget appBar = UniversalPlatform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(title),
            trailing: Row(children: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ]),
          )
        : AppBar(
            title: const Text(title),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          ) as PreferredSizeWidget;

    final txListWidget = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    SizedBox txChartBarWidget(double height) => SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            height,
        child: Chart(_recentTransactions));

    final pageBody = Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (isLandscape)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            const Text("Mirar gráfico"),
            Switch.adaptive(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: _showChart,
                onChanged: (state) {
                  setState(() {
                    _showChart = state;
                  });
                })
          ]),
        if (!isLandscape) txChartBarWidget(0.3),
        if (!isLandscape) txListWidget,
        if (isLandscape) _showChart ? txChartBarWidget(0.7) : txListWidget,
      ],
    );
    return UniversalPlatform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: !UniversalPlatform.isAndroid
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
