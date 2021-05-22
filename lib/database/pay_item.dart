import 'package:accounting/database/pay_category.dart';
import 'package:accounting/tools/functools.dart';
import 'package:accounting/tools/json.dart';
import 'package:decimal/decimal.dart';

class PayItem {
  Decimal _paySum = Decimal.zero;
  String description = '';

  late int id;
  late DateTime date;
  late PayCategory payCategory;

  PayItem({required int id, required DateTime date, required Decimal? paySum, String? description, PayCategory? payCategory}) {
    this.paySum = paySum;
    this.id = id;
    this.date = date;
    this.description = coalesce(description, '');
    this.payCategory = coalesce(payCategory, PayCategory.fromJson(PayCategory.defaultValues()[0]));
  }

  Decimal get paySum => _paySum;
  set paySum(Decimal? value) {
    if (value == null) {
      value = Decimal.zero;
    }
    _paySum = value;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  static PayItem fromJson(Map<String, dynamic> json) {
    return PayItem(
      id: int.parse(json['id'].toString()),
      date: DateTime.parse(json['date']),
      paySum: Decimal.parse(json['paySum'].toString()),
      description: json['description'],
      payCategory: PayCategory.fromJson(startsWith(json, 'PayCategory'))
    );
  }
}