
FAui faui; 

abstract class IAuiUser{
  String email;
}

abstract class FAui{
  IAuiUser fAuiUser; 
  get user => fAuiUser;
  static delegate(x){
    faui = x;
  }
}

