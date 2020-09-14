class ParseData {
  int _id;
  String _title;
  String _text;
  String _time;

  // konstruktor versi 1
  ParseData(this._id, this._title, this._text, this._time);

  // konstruktor versi 2: konversi dari Map ke ParseData
  ParseData.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._text = map['text'];
    this._time = map['time'];
  }

  // getter
  // ignore: unnecessary_getters_setters
  int get id => _id;
  // ignore: unnecessary_getters_setters
  String get title => _title;
  // ignore: unnecessary_getters_setters
  String get text => _text;
  // ignore: unnecessary_getters_setters
  String get time => _time;

  // setter
  // ignore: unnecessary_getters_setters
  set id(int value) {
    _id = value;
  }

  // ignore: unnecessary_getters_setters
  set title(String value) {
    _title = value;
  }

  // ignore: unnecessary_getters_setters
  set text(String value) {
    _text = value;
  }

  // ignore: unnecessary_getters_setters
  set time(String value) {
    _time = value;
  }

  // konversi dari ParseData ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['title'] = title;
    map['text'] = text;
    map['time'] = time;
    return map;
  }
}
