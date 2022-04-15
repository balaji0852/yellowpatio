import 'package:floor/floor.dart';
import 'package:yellowpatioapp/db/entity/class_master.dart';


// @TypeConverters([DateTimeConverter])
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


  DataInstancesMaster(
      {this.dataInstanceID,
      required this.itemMasterID, 
      required this.dataInstances,
      required this.instancesTime
     });
}
