import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable()
class ApiResponse {
  bool? success;
  bool? error;
  String? message;
  dynamic data;
  int? statusCode;

  ApiResponse(this.error,
      {this.success, this.message, this.data, this.statusCode});

  @override
  String toString() {
    return 'ApiResponse(success: $success, error: $error)';
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    //print(json.toString());

    return _$ApiResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
