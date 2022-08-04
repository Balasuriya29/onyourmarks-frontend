class UserModel{
  String? _username;
  String? _user_id;
  bool? _isAdmin;
  bool? _isRegistered;

  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  String? get user_id => _user_id;

  bool? get isRegistered => _isRegistered;

  set isRegistered(bool? value) {
    _isRegistered = value;
  }

  bool? get isAdmin => _isAdmin;

  set isAdmin(bool? value) {
    _isAdmin = value;
  }

  set user_id(String? value) {
    _user_id = value;
  }

  UserModel(this._username, this._user_id, this._isAdmin, this._isRegistered);

  UserModel.empty(this._username,this._isRegistered);
}