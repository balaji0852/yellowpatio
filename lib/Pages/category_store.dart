

class CategoryStore{
  
  static final _categories = ['finance','default'];
  static final _subCategories = [['expenditure','savings','stock','interest'],['default']];
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