class MyStack {
  List stack = [];
  
  MyStack() {
    stack = [];
  }
  
  MyStack.fillStack(List values) {
    stack = values;
  }

  void push(value) {
    stack.add(value);
  }

  pop() {
    if (stack.isEmpty) {
      return;
    }
    return stack.removeLast();
  }

  get peek {
    if (stack.isEmpty) {
      return;
    }
    return stack.last;
  }

  void clear() {
    stack.clear();
  }

  bool get isEmpty => stack.isEmpty;
  bool get isNotEmpty => stack.isNotEmpty;
  int get length => stack.length;
}
