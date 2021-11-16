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

  PreferredSizeWidget _buildAppBar() {
    return UniversalPlatform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(title),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context)),
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
  }

  SizedBox _txChartBarWidget(
    double height,
    MediaQueryData mediaQuery,
    AppBar appBar,
  ) =>
      SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              height,
          child: Chart(_recentTransactions));

  SizedBox _txListWidget(
    MediaQueryData mediaQuery,
    AppBar appBar,
  ) =>
      SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.7,
          child: TransactionList(_userTransactions, _deleteTransaction));

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
  ) {
    return [
      _txChartBarWidget(0.3, mediaQuery, appBar),
      _txListWidget(mediaQuery, appBar)
    ];
  }

  SizedBox _buildChangeChartBarOrTxList(
    bool showChart,
    MediaQueryData mediaQuery,
    AppBar appBar,
  ) {
    return showChart
        ? _txChartBarWidget(0.7, mediaQuery, appBar)
        : _txListWidget(mediaQuery, appBar);
  }

  List<Widget> _buildLandscapeContent(bool showChart, MediaQueryData mediaQuery,
      AppBar appBar, ThemeData theme) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text("Mirar gráfico", style: theme.textTheme.headline6),
        Switch.adaptive(
            activeColor: theme.colorScheme.secondary,
            value: _showChart,
            onChanged: (state) {
              setState(() {
                _showChart = state;
              });
            })
      ]),
      _buildChangeChartBarOrTxList(showChart, mediaQuery, appBar)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = _buildAppBar();
    final theme = Theme.of(context);
    var isLandscape = !(UniversalPlatform.isDesktop || UniversalPlatform.isWeb);
    if (isLandscape) {
      isLandscape = mediaQuery.orientation == Orientation.landscape;
    }
    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            ..._buildLandscapeContent(
                _showChart, mediaQuery, appBar as AppBar, theme),
          if (!isLandscape)
            ..._buildPortraitContent(mediaQuery, appBar as AppBar),
        ],
      ),
    ));
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
