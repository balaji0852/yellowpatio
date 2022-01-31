import 'package:floor/floor.dart';

@entity
class Label {
  @PrimaryKey(autoGenerate: true)
  final int? labelId;

  final String labelName;

  Label({this.labelId, required this.labelName});
}
