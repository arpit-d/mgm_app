import 'dart:io';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
part 'moor_database.g.dart';

class MedicinesTable extends Table {
  // autoincrement sets this to the primary key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 5, max: 50)();
  TextColumn get dose => text()();
}
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}
@UseMoor(tables: [MedicinesTable])
class MyDatabase extends _$MyDatabase {
   MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  
  Future<List<MedicinesTableData>> getAllMedicines() =>
      select(medicinesTable).get();
  Future insertMedicine(MedicinesTableData medicine) =>
      into(medicinesTable).insert(medicine);
  Future updateMedicine(MedicinesTableData medicine) =>
      update(medicinesTable).replace(medicine);
  Future deleteMedicine(MedicinesTableData medicine) =>
      delete(medicinesTable).delete(medicine);

}
