 
 
 looper(int iVal, int jVal, Function(int i, int j) callBack,{int startIValue=0,int startJValue=0}) {
    for (int i = startIValue; i < iVal; i++) {
      for (int j = startJValue; j < jVal; j++) {
        callBack(i, j);
      }
    }
  }