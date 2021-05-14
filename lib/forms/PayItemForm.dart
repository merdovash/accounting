import 'package:accounting/database/database.dart';
import 'package:accounting/registry/registry_item.dart';
import 'package:accounting/tools/types.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PayItemForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final PayItem payItem;

  PayItemForm(this.payItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
                name: 'paySum',
            ),
            ElevatedButton(
              onPressed: ()  {
                final state = _formKey.currentState;
                if (state == null) return;
                state.save();
                final fields = state.fields;
                payItem.paySum = safe_cast<Decimal>(Decimal.tryParse(fields['paySum']?.value), payItem.paySum);

                DatabaseConnection().rawQuery(
                  '''
                  insert into "Pay" (date, description, paySum) values (?, ?, ?)
                  ''',
                  [payItem.date, '', payItem.paySum]
                );
              },
              child: Text('Сохранить'),
            )
          ]
        ),
        onChanged: () => print('hello'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: {
          'paySum': payItem.paySum.toString(),
        },
      )
    );
  }

}