class PinCodeModel {
  bool? result;
  String? message;
  String? email;
  String? code;
  String? errorMessage;
  ValidationError? validationError;

  PinCodeModel({
    this.result,
    this.message,
    this.email,
    this.errorMessage,
    this.validationError,
    this.code,
  });

  PinCodeModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    errorMessage = json['error'];
    validationError = json['validation_error'] != null
        ? ValidationError.fromJson(json['validation_error'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['token'] = code;
    return data;
  }
}

class ValidationError {
  List<String>? token;

  ValidationError({this.token});

  ValidationError.fromJson(Map<String, dynamic> json) {
    token = json['token'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    return data;
  }
}
