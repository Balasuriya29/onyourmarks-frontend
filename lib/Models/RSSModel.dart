class RSSModel{
  String? _title;
  String? _content;
  String? _category;
  String? _url;

  String? get title => _title;

  set title(String? value) {
    _title = value;
  }

  String? get url => _url;

  set url(String? value) {
    _url = value;
  }

  String? get content => _content;

  set content(String? value) {
    _content = value;
  }

  String? get category => _category;

  set category(String? value) {
    _category = value;
  }

  RSSModel(this._title, this._content, this._url);
}