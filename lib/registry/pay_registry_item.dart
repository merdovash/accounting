import 'package:accounting/registry/registry_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistryPayItem extends StatelessWidget {
  final PayItem payItem;
  RegistryPayItem(this.payItem);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(DateFormat("dd.MM.yy", 'RU-ru').format(payItem.date)),
      title: Text(payItem.paySum.toString() + '₽'),
    );
  }

}