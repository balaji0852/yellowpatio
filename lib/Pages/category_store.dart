

class CategoryStore{
  
  static final _categories = ['finance','default'];
  //balaji - sig 34: adding category is not planned or drafted, 
  //        sig 34 gets temporary fix, since e-app gives 1-1 as category,
  //         universal fix solves this issues.
  static final _subCategories = [['expenditure','savings','stock','interest'],['default','default']];
  List<String>? _subCategoryList;


  CategoryStore(){_subCategoryList = _subCategories.elementAt(1);}

  get getCategoryList{
    return _categories;
  }
  

  get getSubCategoryList{
    return _subCategoryList;
  }

  set setSubCategoryList(String category){
    _subCategoryList = _subCategories.elementAt(_categories.indexOf(category));
  }


}