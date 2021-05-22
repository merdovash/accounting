import 'package:accounting/database/database.dart';
import 'package:accounting/database/pay_category.dart';
import 'file:///C:/self/AndroidStudioProjects/accounting/lib/database/pay_item.dart';
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
    var defaultPayCategories = PayCategory.defaultValues().map(PayCategory.fromJson).toList();


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
            FutureBuilder(
              initialData: FormBuilderDropdown<PayCategory>(
                name: 'payCategory',
                items:  defaultPayCategories
                    .map(payCategoryElement)
                    .toList()
              ),
              future: DatabaseConnection().rawQuery('select * from "PayCategory"').then((List<Map<String, dynamic>> res) {
                var result = res.map(PayCategory.fromJson).toList();
                //defaultPayCategories = result;
                return result;
              }),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return FormBuilderDropdown<PayCategory>(
                      name: 'payCategory',
                      items: safe_cast<List<PayCategory>>(
                          snapshot.data,
                          defaultPayCategories,
                      )
                          .map(payCategoryElement)
                          .toList()
                  );
                }
                return FormBuilderDropdown<PayCategory>(
                    name: 'payCategory',
                    items: defaultPayCategories
                        .map(payCategoryElement)
                        .toList()
                );
              }
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
                payItem.payCategory = safe_cast<PayCategory>(fields['payCategory']?.value, defaultPayCategories[0]);

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
          'payCategory': payItem.payCategory,
        },
      )
    );
  }

  saveToDB() {
    if (payItem.id <= 0) {
      DatabaseConnection().rawQuery(
        '''
        insert into "Pay" (date, description, paySum, payCategory) values (?, ?, ?, ?)
        ''',
        [payItem.date, '', payItem.paySum, payItem.payCategory.id]
      );
    } else {
      DatabaseConnection().rawQuery(
        '''
        update "Pay" 
        set (date, description, paySum, payCategory) = (?, ?, ?, ?)
        where "id" = ?
        ''',
        [payItem.date, '', payItem.paySum, payItem.payCategory.id, payItem.id]
      );
    }
  }

  DropdownMenuItem<PayCategory> payCategoryElement(PayCategory category) {
    return DropdownMenuItem<PayCategory>(
      child: Text(category.name),
      value: category,
    );
  }

}