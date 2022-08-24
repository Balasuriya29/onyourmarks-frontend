class HomeWorkModel{
  String? _title;
  String? _description;
  String? _teacher_name;
  String? _date;
  String? _subject;
  String? _std_name;

  String? get title => _title;

  set title(String? value) {
    _title = value;
  }

  String? get description => _description;

  String? get subject => _subject;

  set subject(String? value) {
    _subject = value;
  }

  String? get date => _date;

  set date(String? value) {
    _date = value;
  }

  String? get teacher_name => _teacher_name;

  set teacher_name(String? value) {
    _teacher_name = value;
  }

  set description(String? value) {
    _description = value;
  }

  String? get std_name => _std_name;

  set std_name(String? value) {
    _std_name = value;
  }

  HomeWorkModel.forStudents(this._title, this._description, this._teacher_name, this._date,
      this._subject);

  HomeWorkModel.forTeachers(this._title, this._description, this._teacher_name,
      this._date, this._subject, this._std_name);
}