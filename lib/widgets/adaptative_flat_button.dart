import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class AdaptativeFlatButton extends StatelessWidget {
  final String title;
  final VoidCallback action;
  const AdaptativeFlatButton(
    this.title,
    this.action, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? CupertinoButton(
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: action,
          )
        : TextButton(
            style: TextButton.styleFrom(
              // backgroundColor: Theme.of(context).primaryColor,
              primary: Theme.of(context).primaryColorDark,
              padding: const EdgeInsets.all(10),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: Text(title),
            onPressed: action,
          );
  }
}
