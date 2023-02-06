import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../data/user/user.dart';
import '../../main.dart';
import '../../presentation/utils/strings.dart';
import '../repositories/auth_repo.dart';
import 'response/responses.dart';

class AuthProvider extends GetConnect {
  static AuthProvider get value => Get.find<AuthProvider>();

  get _userType => 'AuthRepository.instance.user.value.type.name';

  get _id => AuthRepository.instance.user.value.id;

  @override
  void onInit() {
    httpClient.baseUrl = AppStrings.baseUrl;

    httpClient.defaultDecoder = (val) {
      //print(val);

      if (val is String) {
        print(val);
        return ApiResponse(true,
            status: false, message: 'Invalid Response returned');
      }
      return ApiResponse.fromJson(val);
    };

    // Http and websockets if used with no [httpClient] instance

    // It's will attach 'apikey' property on header from all requests

    httpClient.addRequestModifier((Request request) {
      if (AuthRepository.instance.user.value.token != null) {
        request.headers['Authorization'] =
            'Bearer ${AuthRepository.instance.user.value.token!.access_token}';
      }
      return request;
    });

/*     httpClient.addAuthenticator((Request request) async {
      var resp;
      var response;
      var token;
      var refreshToken;

      var body = {
        "refreshToken": AuthRepository.instance.user.value.refreshToken
      };

      //  try {
      resp = await post<ApiResponse>('/$_userType/refresh-token', body);
      response = getErrorMessage(resp);
      if (response != null) {
        AuthRepository.instance.user.value = User();
        Get.offAllNamed(Routes.customerTypeScreen);
        Get.showSnackbar(GetSnackBar(
          message: response,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ));
        await Future.delayed(Duration(milliseconds: 3100));
        Get.closeAllSnackbars();
      } else {
        token = resp.body.data['token'];
        refreshToken = resp.body.data['refreshToken'];

        AuthRepository.instance.user.value = AuthRepository.instance.user.value
            .copyWith(refreshToken: refreshToken, token: token);

        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
      //}  catch (e) {

      // return request;

      // }
    }); */

    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 1;
    httpClient.timeout = Duration(seconds: 30);

    // Does Rubish
    // httpClient.addResponseModifier<ApiResponse>(
    //   (request, response) {
    //     print(request.decoder.toString());
    //     print(response.bodyString);

    //     return response.body;
    //   },
    // );
    appDebugMode.listen((_) => httpClient.baseUrl = AppStrings.baseUrl);
  }

/*   Future<CustomerProfile> fetchCustomerProfile() async {
    return get<ApiResponse>('/$_userType/$_id').then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ profile $response');
      }

      return CustomerProfile.fromJson(response);
    });
  }

  Future<VendorProfile> fetchVendorProfile() async {
    return get<ApiResponse>('/$_userType/$_id?_id=$_id').then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ profile $response');
      }

      return VendorProfile.fromJson(response);
    });
  }

  Future<UnverifiedVendorProfile> fetchUnVerifiedVendorProfile() async {
    return get<ApiResponse>('/$_userType/$_id/profile').then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ profile $response');
      }

      return UnverifiedVendorProfile.fromJson(response);
    });
  }
 */

/*   Future<ApiResponse> updateDetails(
      {required Address address,
      required String restuarantName,
      required String coverPhoto,
      required String description,
      required OperatingHours operatingHours,
      required String? regNum,
      String? vendorId}) async {
    String url = '/$_userType/$_id/complete-restaurant-profile';

    return put<ApiResponse>(url, {
      "address": address.toJson(),
      "restaurantName": restuarantName,
      "coverPhoto": coverPhoto,
      "description": description,
      "regNum": regNum ?? '',
      "operatingHours": operatingHours.toJson(),
      "vendorId": vendorId
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body;
        }

        return response;
      },
    );
  } */

  // Future<String?> updateRestaurantProfile(String path) {
  //   final FormData formData = FormData({
  //     "address": "VGC Lekki, Lagos state",
  //     "city": "Lekki, Lagos",
  //     "coverPhoto": MultipartFile(path, filename: 'upload'),
  //     "businessName": "mama cass",
  //     "regNum": "rc746373BH"
  //   });

  //   return put<ApiResponse>(
  //           '$_userType/62d5b1a960a4cf3edc52e8a7/restaurant-profile/edit',
  //           formData)
  //       .then(
  //     (value) {
  //       var response;

  //       // Check for error
  //       response = getErrorMessage(value);
  //       if (response != null) {
  //         throw (response);
  //       } else {
  //         // return URL
  //         response = value.body?.data;
  //       }
  //       return response;
  //     },
  //   );
  // }

  // Future<String?> fetchAccountName({
  //   accountNumber,
  //   bankCode
  //   }) {
  //   return post<ApiResponse>('$_userType/vendor/banks/verify-account?bankCode=044&accountNumber=0099789249', {
  //     "account_number": accountNumber,
  //     "bank_code": bankCode,

  //   }).then(
  //     (value) {
  //       var response;

  //       //Check for error
  //       response = getErrorMessage(value);
  //       if (response != null) {
  //         throw (response);
  //       } else {
  //         // Send response
  //         response = value.body!.data["account_name"];
  //       }

  //       return response;
  //     },
  //   );
  // }

/*   Future<String?> uploadAddress(Address address) {
    return put<ApiResponse>('/$_userType/$_id/profile', {
      'address': address.toJson(),
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  // Working
  Future<List<Bank>> fetchBanks(String vendorId) {
    return get<ApiResponse>(
      '/$_userType/$vendorId/banks',
    ).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = (value.body!.data as List<dynamic>)
              .map((e) => Bank.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return response;
      },
    );
  }

  // Working
  Future<List<menu.MenuCategory>> fetchCategories(String vendorId) {
    return get<ApiResponse>(
      '/$_userType/$vendorId/menu-categories?default=false',
    ).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = (value.body!.data['category'] as List<dynamic>)
              .map((e) => menu.MenuCategory.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return response;
      },
    );
  }

  Future<List<menu.MenuCategory>> fetchSuggestionCategories(String vendorId) {
    return get<ApiResponse>(
      '/$_userType/$vendorId/menu-categories?default=true',
    ).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = (value.body!.data['category'] as List<dynamic>)
              .map((e) => menu.MenuCategory.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return response;
      },
    );
  }

  Future<List<Bank>> fetchLogoBanks() {
    return GetConnect(timeout: Duration(seconds: 30))
        .get(
      'https://nigerianbanks.xyz',
    )
        .then(
      (response) {
        //print(response.bodyString);
        //Check for error
        //response = getErrorMessage(value);
        if (response.body == null || !response.status.isOk) {
          throw ("Error: Couldn't connect to the internet to load banks. Please check your connection");
        }

        return (response.body as List<dynamic>)
            .map((e) => Bank.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<List<Bank>> fetchPaystackBanks() {
    return get(
      'https://api.paystack.co/bank',
      headers: {
        'Authorization': 'sk_test_ae083a71b50babe217810b61f33ea73c5741d2df'
      },
      query: {
        'country': 'nigeria',
        'use_cursor': 'false',
        'currency': 'NGN',
      },
    ).then(
      (response) {
        //print(response.bodyString);
        //Check for error
        //response = getErrorMessage(value);
        if (response.body == null) {
          throw ("Error: Couldn't connect to the internet to load banks. Please check your connection");
        }

        // if (BankResponse.fromJson(response.body).status == false) {
        //   throw (BankResponse.fromJson(response.body).message);
        // }

        return BankResponse.fromJson(response.body).banks;
      },
    );
  }
 */
  Future<String?> setPassword(String email, password, otp) {
    return post<ApiResponse>('auth/$_userType/reset-password', {
      'email': email,
      'password': password,
      'otp': otp,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = 'Password reset successfully \nLog in to continue';
        }

        return response;
      },
    );
  }

  // Working
  Future<String?> resetPassword(String email, newPassword, otp) {
    return post<ApiResponse>('/$_userType/reset-password/otp', {
      'email': email,
      'newPassword': newPassword,
      'otp': otp,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          print(response);
          throw (response);
        } else {
          response = 'Password reset successfully \nLog in to continue';
        }

        return response;
      },
    );
  }

  Future<String?> changePassword(String userId, oldPassword, newPassword) {
    var body = {
      // _userType == UserType.customer.name ? "customerId" : "vendorId": userId,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };

    return post<ApiResponse>('/$_userType/reset-password', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        print(value);
        if (response != null) {
          //  print(response);
          throw (response);
        } else {
          response = 'Password changed successfully';
        }

        return response;
      },
    );
  }

  // Future<String> sendPasswordResetOtp(String email) {
  //   return post<ApiResponse>('auth/$_userType/resend_verification_email', {
  //     'email': email,
  //   }).then(
  //     (value) {
  //       var response;

  //       //Check for error
  //       response = getErrorMessage(value);
  //       if (response != null) {
  //         throw (response);
  //       } else {
  //         response = 'OTP Sent successfully';
  //       }

  //       return response;
  //     },
  //   );
  // }

  // Working
  Future<String> forgotPassword(String email) {
    return post<ApiResponse>('/$_userType/forgot-password', {
      'email': email,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = 'OTP Sent successfully';
        }

        return response;
      },
    );
  }

  // Working
  Future<String?> verifyEmail({
    required String email,
    required String otp,
  }) {
    return post<ApiResponse>('/$_userType/verify-account', {
      "email": email,
      "otp": otp,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = 'Email verified';
        }
        return response;
      },
    );
  }

  // Working
  Future<String> resendOtp(
    String email,
  ) {
    return post<ApiResponse>('/$_userType/resend-verification-otp', {
      "email": email,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = 'OTP Resent';
        }
        return response;
      },
    );
  }

  // Working
  Future<String> sendPinOtp() {
    return get<ApiResponse>('/$_userType/$_id/wallet/forgot-pin').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body?.message ?? 'OTP Resent';
        }
        return response;
      },
    );
  }

  Future<String> submitPinOtp(String otp) {
    return post<ApiResponse>('/$_userType/wallet/reset-pin/otp', {
      "vendorId": _id,
      "otp": otp,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body?.message ?? 'OTP Submitted';
        }
        return response;
      },
    );
  }

  Future<User> signup({
    required String username,
    required String email,
    required String password,
  }) {
    return post<ApiResponse>('/auth/signup', {
      "email": email,
      "username": username,
      "password": password,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = User.fromJsonWithToken(
              value.body?.data['user'], value.body?.data['token']);
        }

        return response;
      },
    );
  }

  Future<Wallet> fetchWallet() async {
    return get<ApiResponse>('/payments/wallet').then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('wallet $response');
      }

      return Wallet.fromJson(response);
    });
  }

  Future<String> payMoney({
    required String id,
    required num amount,
  }) {
    return post<ApiResponse>('/payments/pay/{$id}?amount=$amount', {}).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body?.message;
        }

        return response;
      },
    );
  }

/*   Future<User> vendorSignUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String referrer,
    required UserType type,
    required String branchEmail,
    // required String userName,
    // required String inviteCode,
  }) {
    var body = {
      "vendorName": name,
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "user_type": type.name,
      "parentCompanyMail": branchEmail
      // "userName": userName,
      // 'invite_code': inviteCode
    };

    body.addIf(referrer.isNotEmpty, 'referrer', referrer);
    return post<ApiResponse>('/$_userType/register', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = User.fromJsonWithType(value.body?.data, type: type);
        }

        return response;
      },
    );
  } */
/* 
  Future<User> delCartItem({required String cartId, required UserType type}) {
    return post<ApiResponse>('/$_userType/$_id/cart/$cartId', {}).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = User.fromJsonWithType(value.body?.data, type: type);
        }

        return response;
      },
    );
  }
 */
  // Working
/*   Future<User> login(email, password) {
    var body = {
      'email': email,
      'password': password,
    };
    return post<ApiResponse>('/$_userType/login', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Convert to Model

          response = User.fromJson(value.body?.data);

          //response = User.fromJson(value.body?.data,  type: userType);
        }

        return response;
      },
    );
  }
 */
/*   Future<User> contactSupport(name, email, message) {
    return post<ApiResponse>('/contact-support', {
      'name': name,
      'email': email,
      'message': message,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Convert to Model

          response = User.fromJson(value.body?.data);

          //response = User.fromJson(value.body?.data,  type: userType);
        }

        return response;
      },
    );
  } */

  Future<String?> completeRestaurantProfile(bool status) {
    var body = {"completedProfile": "$status"};

    return put<ApiResponse>('/$_userType/$_id/completed-profile', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body?.message;
        }

        return response;
      },
    );
  }

  // Working
  Future<String> fetchAccountName(
      String accountNumber, String bankCode, String vendorId) {
    return get<ApiResponse>(
      '/$_userType/$vendorId/banks/verify-account?bankCode=$bankCode&accountNumber=$accountNumber',
    ).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        print(value);
        if (response != null) {
          throw (response);
        } else {
          // Convert to Model
          response = value.body?.data['account_name'];
        }
        return response;
      },
    );
  }

  Future<String> fetcxhWallet(String limit, String sort, String vendorId) {
    return get<ApiResponse>(
      '/$_userType/$vendorId/wallet?limit=$limit&sort=$sort',
    ).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        print(value);
        if (response != null) {
          throw (response);
        } else {
          // Convert to Model
          response = value.body?.data['account_name'];
        }
        return response;
      },
    );
  }
}

String? getErrorMessage(Response<ApiResponse> response) {
  if (kDebugMode) {
    log(' Status Code: ${response.statusCode}');
    log(' Status Text: ${response.statusText}');
    log(' Response Body: ${response.bodyString}');
    log(' Headers: ${response.request?.headers.toString()}');
    log(' URL: ${response.request?.url}');
  }

  if (response.statusCode != null &&
      response.isOk &&
      (response.body!.status == true || response.body!.error == false)) {
    print('Response is okay: ${response.isOk}');
    return null;
  } else if (response.body == null) {
    // Send Error Locally
    return "Error: Couldn't connect to the internet, check your connection";
  } else if (response.body!.message != null) {
    return response.body!.message;
  } else {
    return 'Something went wrong, please try again later';
  }
}
