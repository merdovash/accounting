import 'package:accounting/database/database.dart';
import 'package:accounting/registry/registry_item.dart';
import 'package:accounting/tools/types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class PayItemForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final PayItem payItem;

  PayItemForm(this.payItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(payItem.id <=0 ? 'Добавление платежа': 'Платеж'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.numeric(context),
                FormBuilderValidators.min(context, 0, inclusive: false)
              ]),
              decoration: InputDecoration(
                labelText: 'Сумма',
                suffix: Text('₽')
              ),
              name: 'paySum',
            ),
            FormBuilderDateTimePicker(
              name: 'date',
              decoration: InputDecoration(
                labelText: 'Дата',
              ),
              inputType: InputType.date,
              format: DateFormat('dd.MM.yy'),
              //timePickerInitialEntryMode: null,
            ),
            FormBuilderTextField(
              name: 'description',
              decoration: InputDecoration(
                labelText: 'Назначение',
              ),
            ),
            ElevatedButton(
              onPressed: ()  {
                final state = _formKey.currentState;
                if (state == null) return;
                state.save();
                final fields = state.fields;
                payItem.paySum = safe_cast<Decimal>(Decimal.tryParse(fields['paySum']?.value), payItem.paySum);
                payItem.date = safe_cast<DateTime>(fields['date']?.value, DateTime.now());
                payItem.description = safe_cast<String>(fields['description']?.value, '');

                saveToDB();
                Navigator.pop(context, payItem);
              },
              child: Text('Сохранить'),
            )
          ]
        ),
        onChanged: () => print('hello'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: {
          'paySum': payItem.paySum.toString(),
          'date': payItem.date,
          'description': payItem.description,
        },
      )
    );
  }

  saveToDB() {
    if (payItem.id <= 0) {
      DatabaseConnection().rawQuery(
        '''
        insert into "Pay" (date, description, paySum) values (?, ?, ?)
        ''',
        [payItem.date, '', payItem.paySum]
      );
    } else {
      DatabaseConnection().rawQuery(
        '''
        update "Pay" 
        set (date, description, paySum) = (?, ?, ?)
        where "id" = ?
        ''',
        [payItem.date, '', payItem.paySum, payItem.id]
      );
    }
  }

}