class RegexConstant {
  static RegexConstant? _instance;
  static RegexConstant get instance {
    _instance ??= RegexConstant._init();
    return _instance!;
  }

  RegexConstant._init();

  String emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}
