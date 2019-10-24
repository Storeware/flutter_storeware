library classes;

abstract class Base {
  log(String v) {
    print('classes-> $v');
  }
}

abstract class Bloc with Base {}

abstract class Component with Base {}

abstract class Model with Base {}

abstract class View with Base {}

abstract class Controller with Base {}


