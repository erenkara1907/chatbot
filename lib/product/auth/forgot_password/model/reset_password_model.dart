class ResetPasswordModel {
  bool? result;
  String? message;
  String? email;
  String? errorMessage;
  ValidationError? validationError;
  String? password;

  ResetPasswordModel({
    this.result,
    this.message,
    this.email,
    this.errorMessage,
    this.validationError,
    this.password,
  });

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
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
    data['password'] = password;
    return data;
  }
}

class ValidationError {
  List<String>? email;

  ValidationError({this.email});

  ValidationError.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}
