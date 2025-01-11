 
 
 looper(int iVal, int jVal, Function(int i, int j) callBack) {
    for (int i = 0; i < iVal; i++) {
      for (int j = 0; j < jVal; j++) {
        callBack(i, j);
      }
    }
  }