class API {
  static const hostconnect = "http://am1009n.dothome.co.kr";
  static const hostconnectUser = "$hostconnect/user";

  static const signup = "$hostconnect/user/signup.php";
  static const signup_test = "$hostconnect/user/signup_test.php";
  //static const login = "$hostconnect/user/login.php";
  static const login = "$hostconnect/Login.php";
  static const loginUpdate = "$hostconnect/Login_Update.php";

  // order
  static const addOrder = "$hostconnect/Order_Insert.php";
  static const updateOrder = "$hostconnect/Order_Update.php";
  static const deleteOrder = "$hostconnect/Order_Delete.php";

  static const register = "$hostconnect/Register.php";
  static const validateID = "$hostconnect/user/validation.php";
  static const board = "$hostconnect/BOARD.php";
  static const order_D_HISTORY = "$hostconnect/ORDERBOARD_D_History.php";
  static const order_ADD = "$hostconnect/Order.php";
  static const order_HISTORY = "$hostconnect/ORDERBOARD_COMPLETE.php";
  static const orderBoard = "$hostconnect/ORDERBOARD.php";
  static const orderBoard_orderYN = "$hostconnect/ORDERBOARD_orderYN.php";

  static const UpdatePassWord = "$hostconnect/Update_PassWord.php";
  static const UpdateTel = "$hostconnect/Update_Tel.php";
  static const UpdateCom = "$hostconnect/Update_Company.php";
  static const UpdateComNo = "$hostconnect/Update_ComNo.php";
  static const UpdateCarNO = "$hostconnect/Update_CarNo.php";

  static const DriverOrder_all = "$hostconnect/DriverOrder_all.php";

  static const UpdateCancelCount = "$hostconnect/cancelCnt_Update.php";
  static const UpdateOrderYN = "$hostconnect/Update_OrderYN.php";
  static const UpdateConfirmYN = "$hostconnect/Order_ConfirmYN_Update.php";

  //상차지
  static const StartArea = "$hostconnect/DriverOrder_StartArea.php";
  //하차지
  static const EndArea = "$hostconnect/DriverOrder_EndArea.php";
  //제강사
  static const Steel = "$hostconnect/DriverOrder_Steel.php";
}
