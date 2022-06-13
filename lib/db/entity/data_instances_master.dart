import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';
import 'dart:convert';

@Entity(
  tableName: 'DataInstancesMaster',
  foreignKeys: [
    ForeignKey(
      childColumns: ['itemMasterID'],
      parentColumns: ['itemMasterID'],
      entity: ClassMaster,
    )
  ],
)
class DataInstancesMaster {
  @PrimaryKey(autoGenerate: true)
  final int? dataInstanceID;

  final int itemMasterID;

  final String dataInstances;

  final int instancesTime;

  final int instancesStatus;

  DataInstancesMaster(
      {this.dataInstanceID,
      required this.itemMasterID,
      required this.dataInstances,
      required this.instancesTime,
      required this.instancesStatus});

  String toJsonString() {
    return jsonEncode(<String, dynamic>{
      'dataInstances': dataInstances,
      'instanceTime':instancesTime,
      'classMaster': {'itemMasterID': 63},
    });
  }
}
