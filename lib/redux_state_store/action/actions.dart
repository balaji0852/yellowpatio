

import '../../db/entity/class_data_instanceMaster.dart';

class ChangeDateViewPreference{
  final int userDateViewPreference;

  ChangeDateViewPreference(this.userDateViewPreference);
}


class ChangeBottomNavigationView{
  final int selectedIndex;

  ChangeBottomNavigationView(this.selectedIndex);
}


class ChangeDarkMode{
  final bool DarkMode;

  ChangeDarkMode(this.DarkMode);
}

//using to store projectStoreID
class ChangeProjectStoreID{
  final int projectStoreID;

  ChangeProjectStoreID(this.projectStoreID);
}

//To store userStoreID
class ChangeUserStoreID{
  final int userStoreID;

  ChangeUserStoreID(this.userStoreID);
}

//Balaji : implementing TTC
class DEMODataInstance{

  final ClassDataInstanceMaterDuplicate demoDataInstance;

  DEMODataInstance(this.demoDataInstance);
}



class ChangeShowDialogState{
  final bool showDialog;

  ChangeShowDialogState(this.showDialog);
}


