import 'package:accounting/tools/types.dart';
import 'package:sqflite/sqflite.dart';

class PayCategory {
  static List<Map<String, Object>> defaultValues() {
    return [
      {
        'id': 1,
        'name': 'Расход',
        'direction': -1,
        'description': 'Любой расход',
      },
      {
        'id': 2,
        'name': 'Доход',
        'direction': 1,
        'description': 'Любой доход',
      }
    ];
  }

  late int id;
  late String name;
  late int direction;
  late String description;

  PayCategory(this.id, this.name, this.direction, this.description);

  static PayCategory fromJson(Map<String, dynamic> el) {
    return PayCategory(
        safe_cast<int>(el['id'], 0),
        safe_cast<String>(el['name'], ''),
        safe_cast<int>(el['direction'], -1),
        safe_cast<String>(el['description'], '')
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is PayCategory) return id == other.id;
    return false;
  }

  String sign() => direction>0?'':'-';

}

initTablePayCategory(Database db) async {
  await db.execute(
      '''
            CREATE TABLE IF NOT EXISTS PayCategory (
              id INTEGER PRIMARY KEY,
              direction INTEGER NOT NULL,
              name TEXT NOT NULL,
              description TEXT
            )
          '''
  );

  PayCategory.defaultValues().forEach((Map<String, Object> element) async {
    await db.insert("PayCategory", element);
  });
}