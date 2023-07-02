

import 'package:planb/db/entity/class_data_instanceMaster.dart';
import 'package:planb/db/entity/class_master.dart';


//balaji : 18/3/2023: added this class for lastcomment operations and pinning  
class DataInstanceMasterVO{

  final ClassMaster classMaster;

  final ClassDataInstanceMaterDuplicate classDataInstanceMaterDuplicate;

  final bool pinnedForCurrentUser;

  DataInstanceMasterVO({
    required this.classMaster,
    required this.classDataInstanceMaterDuplicate,
    required  this.pinnedForCurrentUser
  });


}