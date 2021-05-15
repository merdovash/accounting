import 'package:accounting/forms/PayItemForm.dart';
import 'package:accounting/registry/registry_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistryPayItem extends StatefulWidget {
  final PayItem payItem;
  RegistryPayItem(this.payItem);

  @override
  _RegistryPayItemState createState() => _RegistryPayItemState();
}

class _RegistryPayItemState extends State<RegistryPayItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(DateFormat("dd.MM.yy", 'RU-ru').format(widget.payItem.date)),
      title: Text(widget.payItem.paySum.toString() + '₽'),
      onTap: () async {
        PayItem? result = await Navigator.push(
          context,
            MaterialPageRoute(builder: (context) {
              return PayItemForm(
                this.widget.payItem,
              );
            })
        );
        if (result != null) {
          setState(() {
            //widget.payItem.updateFrom(pa);
          });
        }
      },
    );
  }
}