class Chat{
  String? _chat_id;
  String? _message;
  String? _person;

  String? get chat_id => _chat_id;

  set chat_id(String? value) {
    _chat_id = value;
  }

  String? get message => _message;

  String? get person => _person;

  set person(String? value) {
    _person = value;
  }

  set message(String? value) {
    _message = value;
  }

  Chat(this._chat_id, this._message, this._person);

}