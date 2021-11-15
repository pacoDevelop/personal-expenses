import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction(this.addTx, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    DateTime dateNow = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: dateNow,
            firstDate: dateNow.subtract(const Duration(days: 90)),
            lastDate: dateNow)
        .then((data) {
      if (data == null) {
        return;
      }
      setState(() {
        _selectedDate = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Precio'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColorLight),
                        child: Text(
                          _selectedDate == null
                              ? "No hay fecha seleccionada"
                              : DateFormat('dd/MM/yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 19),
                        ),
                      ),
                    ),
                    Expanded(
                      child: UniversalPlatform.isIOS
                          ? CupertinoButton(
                              child: const Text("Seleccione la fecha",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: _presentDatePicker,
                            )
                          : TextButton(
                              style: TextButton.styleFrom(
                                // backgroundColor: Theme.of(context).primaryColor,
                                primary: Theme.of(context).primaryColorDark,
                                padding: const EdgeInsets.all(10),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              child: const Text("Seleccione la fecha"),
                              onPressed: _presentDatePicker,
                            ),
                    ),
                  ],
                ),
              ),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    primary: Theme.of(context).primaryColorLight,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text('Añadir'),
                  onPressed: _submitData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
