/* import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../data/address/AddressPrediction.dart';
import '../data/address/address.dart' as address;
import '../data/combo/add_on.dart';
import '../data/communication/chat_message_model.dart';
import '../data/communication/conversation_model.dart';
import '../data/dish/discounted_dishes.dart';
import '../data/dish/dish_menu.dart';
import '../data/dish/dish_option_item.dart';
import '../data/dish/menu_item_dish.dart';
import '../data/home/home_category.dart';
import '../data/home/home_item.dart';
import '../data/menu/menu.dart';
import '../data/menu/menu_item.dart';
import '../data/menu/search_model.dart' as menu;
import '../data/notification/notification_model.dart';
import '../data/order/cart/cart.dart';
import '../data/order/cart/pay_order_model.dart';
import '../data/order/cart/voucher_model.dart';
import '../data/order/order_list.dart' as customer;
import '../data/order/order_receipt.dart';
import '../data/order/vendor/vendor_orders_model.dart';
import '../data/profile/vendor_profile.dart';
import '../data/retaurant/favourite_menu_model.dart';
import '../data/retaurant/restaurant.dart';
import '../data/retaurant/restaurant_detail.dart';
import '../data/retaurant/restaurant_vendor_data.dart';
import '../data/review_model/customer_review_model.dart';
import '../data/transaction/sales/sale.dart';
import '../data/transaction/transaction_model.dart';
import '../data/transaction/wallet_model.dart';
import '../data/user/user.dart';
import '../domain/providers/response/responses.dart';
import '../domain/repositories/app_repo.dart';
import '../domain/repositories/auth_repo.dart';
import '../main.dart';
import '../presentation/modules/customers/home/controller/home_controller.dart';
import '../presentation/utils/strings.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final printResponses = true;

class AppProvider extends GetConnect {
  late IO.Socket sockett;
  static AppProvider get value => Get.find<AppProvider>();

  get _userType => AuthRepository.instance.user.value.type.name;

  get _id => AuthRepository.instance.user.value.id;

  address.Address? get _address =>
      AuthRepository.instance.user.value.customerProfile?.address;

  @override
  void onInit() {
    /*if (kDebugMode) {
      httpClient.baseUrl = 'https://foodello.herokuapp.com/api/v1';
      //httpClient.baseUrl = 'https://foodelo-beta.herokuapp.com/api/v1';
    } else {
      httpClient.baseUrl = 'https://foodelo-beta.herokuapp.com/api/v1';
    }*/

    httpClient.baseUrl = AppStrings.baseUrl;

    httpClient.defaultDecoder = (val) => ApiResponse.fromJson(val);

    httpClient.errorSafety = true;

    // Http and websockets if used with no [httpClient] instance

    // It's will attach 'apikey' property on header from all requests

    httpClient.addRequestModifier((Request request) {
      if (AppRepository.userIsGuest) {
        // Remove null ID
        String path = request.url.path.replaceFirst('/null', '');

        // Add Address
        final query = {
          'long': _address?.long ?? '0',
          'lat': _address?.lat ?? '0'
        };
        query.addAll(request.url.queryParameters);

        // Return response
        return request.copyWith(
          url: request.url.replace(queryParameters: query, path: path),
        );
      }

      request.headers['Authorization'] =
          'Bearer ${AuthRepository.instance.user.value.token ?? ''}';
      return request;
    });

    // Even if the server sends data from the country "Brazil",
    // it will never be displayed to users, because you remove
    // that data from the response, even before the response is delivered
    // if(AuthRepository.instance.user.value.vendorProfile != null||AuthRepository.instance.user.value.customerProfile != null)
    httpClient.addAuthenticator((Request request) async {
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
    });

    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 1;
    httpClient.timeout = Duration(seconds: 30);

    initSocket();
    appDebugMode.listen((_) {
      httpClient.baseUrl = AppStrings.baseUrl;
      initSocket();
    });
  }

  Future<void> initSocket() async {
    sockett = IO.io(AppStrings.baseDomain, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });

    debugPrint('##################connecting through ${AppStrings.baseDomain}');

    sockett.connect();
    sockett.onConnect((_) {
      goOnline();
      print('Connection established');
      sockett.on('message', (data) {
        debugPrint(' im listening listen to $data');
      });

      sockett.on('order-request', (data) {
        debugPrint(' im listening to order request');
      });
    });
    sockett.onDisconnect((_) {
      print('Connection Disconnection');
    });
    sockett.onConnectError((err) => print(err));
    sockett.onError((err) => print(err));

    goOnline();

    sockett.on('message', (data) {
      debugPrint(' im listening listen to $data');
    });
  }

  /*late AudioPlayer player;
  initAudio() async {
    player = AudioPlayer();
    //await player.setAsset('assets/sounds/ding_dong.mp3');
    player.setAudioSource(
      AudioSource.uri(
        Uri.parse("asset:///assets/sounds/ding_dong.mp3"),
        tag: MediaItem(
          id: 'fd',
          title: "",

        ),
      ),
    );


    player.setVolume(10.0);
    await player.setLoopMode(LoopMode.one);

  }

  void stopPlayer() async{
    player.stop();
  }

  void playPlayer() async{
    player.play();
  }*/

  void goOnline() async {
    sockett.emit(
      "join",
      {"user": _userType == 'customer' ? "Customer" : "Vendor", "userId": _id},
    );
    debugPrint('''############################
    
    
    this user with id $_id joined
    
    
    ###############################################
    ''');
  }

  Future<Analytics> fetchAnalytics(
      {String? date, String? startDate, String? endDate}) {
    final parameters = <String, dynamic>{
      'sort': 'desc',
    };
    parameters.addIf(date?.isNotEmpty ?? false, 'date', date);
    parameters.addIf(startDate?.isNotEmpty ?? false, 'startDate', startDate);
    parameters.addIf(endDate?.isNotEmpty ?? false, 'endDate', endDate);

    return get<ApiResponse>('/$_userType/$_id/analytics', query: parameters)
        .then(
      (value) {
        var response;

        // Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = Analytics.fromJson(value.body!.data);
        }
        return response;
      },
    );
  }

  Future<AddOns> fetchAddons({AddOnType? type}) {
    String url = '/$_userType/$_id/add-on?vendorId=$_id';

    if (type != null) url += '&type=${type.name}';

    return get<ApiResponse>(url).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = (value.body!.data['addOn'] as List<dynamic>)
              .map((e) => AddOn.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return response;
      },
    );
  }

  Future<List<MenuItemDish>> fetchDishes() {
    var param = {"vendorId": _id};
    return get<ApiResponse>('/$_userType/$_id/menu', query: param).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = (value.body!.data['menu'] as List<dynamic>)
              .map((e) => MenuItemDish.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return response;
      },
    );
  }

  Future<String?> addChoiceToItem(String dishId, DishOptionItem choice) {
    return put<ApiResponse>(
            '/$_userType/$_id/item/$dishId/add-choice', choice.toJson())
        .then(
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

  Future<String?> updateItemChoice(String dishId, DishOptionItem choice) {
    return put<ApiResponse>(
            '/$_userType/$_id/choice/$dishId/edit-choice', choice.toJson())
        .then(
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

  Future<List<DishMenuItem>> fetchMenuItems(String menuId) {
    var param = {
      "menuId": menuId,
    };
    return get<ApiResponse>('/$_userType/$_id/menu-items', query: param).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = (value.body!.data['items'] as List<dynamic>)
              .map((e) => DishMenuItem.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return response;
      },
    );
  }

  Future<DishMenuItem> fetchSingleMenuItem(String itemId) {
    var param = {
      "_id": itemId,
    };

    return get<ApiResponse>('/$_userType/$_id/menu-items', query: param).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = DishMenuItem.fromJson(value.body!.data['items'][0]);
        }
        return response;
      },
    );
  }

  Future<String?> deleteDishItem(String itemId) {
    return delete<ApiResponse>(
      '/$_userType/$_id/item/$itemId/remove-item',
    ).then(
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

  Future<String?> deleteChoice(String choiceId) {
    return delete<ApiResponse>(
      '/$_userType/$_id/choice/$choiceId/remove-choice',
    ).then(
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

  Future<String?> deleteMenu(String id) {
    return delete<ApiResponse>(
      '/$_userType/$_id/menu/$id/remove-menu',
    ).then(
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

  Future<String?> deleteAddon(String id) {
    return delete<ApiResponse>(
      '/$_userType/$_id/add-on/$id',
    ).then(
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

  Future<String?> editAddon(String id, Map<String, dynamic> data) {
    return put<ApiResponse>('/$_userType/$_id/add-on/$id', data).then(
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

  Future<List<Cart>?> fetchCartData() {
    var body = {"customerId": _id, "status": "pending"};

    return get<ApiResponse>('/$_userType/$_id/cart', query: body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          // response = value.body!.data['carts'];
          // if (response.length == 0) {
          //   return null;
          // }

          response = (value.body!.data['carts'] as List<dynamic>)
              .map((e) => Cart.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        return response;
      },
    );
  }

  Future<dynamic> fetchCartLength() {
    var body = {"customerId": _id, "status": "pending"};
    return get<ApiResponse>(
      '/$_userType/$_id/homepage-summary',
    ).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data['cartItems'];
        }

        return response;
      },
    );
  }

  Future<WalletModel> fetchUserWalletBalance() async {
    return get<ApiResponse>('/$_userType/$_id').then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data['wallet'];
        debugPrint('+++++++ wallet $response');
      }

      return WalletModel.fromJson(response);
    });
  }

  Future<String?> deleteCartItem(String cartItem, String itemId) {
    return delete<ApiResponse>('/$_userType/$_id/cart/$cartItem/item/$itemId')
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<dynamic> calculateDeliveryFee(
      {required double vendorLat,
      required double vendorLong,
      required double customerLat,
      required double customerLong}) {
    var body = {
      "vendorLong": vendorLong,
      "vendorLat": vendorLat,
      "customerLong": customerLong,
      "customerLat": customerLat
    };

    return post<ApiResponse>('/$_userType/delivery-fee', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return response;
      },
    );
  }

  Future<String?> deleteCart(String cartId) {
    return delete<ApiResponse>('/$_userType/$_id/cart/$cartId').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  //makeshif method

  Future<VoucherModel> validateVoucher(String code, int amount) {
    Map<String, dynamic> body = {
      "customerId": _id,
      "code": code,
      "amount": amount
    };
    return post<ApiResponse>('/$_userType/validate-voucher-code', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return VoucherModel.fromJson(response);
      },
    );
  }

  Future<dynamic> delCartItem(String customerId) {
    return delete<ApiResponse>('/$_userType/$_id/cart/$customerId').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return response;
      },
    );
  }

  // Future<String> uploadMenu({
  //   required String id,
  //   required int prepTime,
  //   required String category,
  //   required AddOns photo,
  //   required String name,
  //   required String price,
  //   required String description,
  //   required AddOns combos,
  // }) {
  //   return post<ApiResponse>('vendor/menu', {
  //     "vendorId": id,
  //     "name": name,
  //     "price": price,
  //     "description": description,
  //     "prepTime": prepTime,
  //     "category": category,
  //     "images": photo.map((e) => e.toOrderJson()).toList(),
  //     "combos": combos.map((e) => e.toOrderJson()).toList(),
  //   }).then(
  //     (value) {
  //       var response;

  //       //Check for error
  //       response = getErrorMessage(value);
  //       if (response != null) {
  //         throw (response);
  //       } else {
  //         // Send response
  //         response = value.body!.message;
  //       }

  //       return response;
  //     },
  //   );
  // }

  Future<String> addItemToCart(
    CartRequest item,
  ) {
    Map<String, dynamic> body = {
      "customerId": item.customerId,
      "itemId": item.itemId,
      "addOns": item.addOns,
      "packs": item.packs
    };

    return post<ApiResponse>('/$_userType/cart/add-item', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<DishMenuItem> fetchDish(String id) {
    return get<ApiResponse>('/$_userType/$_id/menu-item/$id/view-item').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = DishMenuItem.fromJson(value.body!.data);
        }

        return response;
      },
    );
  }

  Future<RestaurantDetail> fetchRestaurant(String id) {
    return get<ApiResponse>('/$_userType/$_id/vendor-page?vendorId=$id').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = RestaurantDetail.fromJson(value.body!.data!);
        }

        return response;
      },
    );
  }

  Future<RestaurantData> fetchRestaurantData(String id) {
    return get<ApiResponse>('$_userType/$_id/vendor-page?vendorId=$id').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = RestaurantData.fromJson(value.body!.data.vendor);
        }

        return response;
      },
    );
  }

  Future<String?> fetchAccountName({
    accountNumber,
    bankCode,
  }) {
    return post<ApiResponse>('shared/bank/verify', {
      "account_number": accountNumber,
      "bank_code": bankCode,
    }).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data["account_name"];
        }

        return response;
      },
    );
  }

  Future<String?> uploadAddon(AddOn addon) {
    return post<ApiResponse>('/$_userType/add-on', addon.toJson()).then(
      (value) {
        var response;

        // Check for error
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

  Future<dynamic> uploadCategory(MenuCategory category) {
    return post<ApiResponse>('/$_userType/menu-category', category.toJson())
        .then(
      (value) {
        var response;

        // Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body!.data;
        }

        return response;
      },
    );
  }

  Future<String?> updateCategory(String categoryId, String newName) {
    var body = {"name": newName};
    return put<ApiResponse>(
            '/$_userType/$_id/menu-category/$categoryId/edit-category', body)
        .then(
      (value) {
        var response;

        // Check for error
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

  Future<List<Choices>> fetchExistingChoices() {
    var paramenters = {
      "vendorId": _id,
    };
    return get<ApiResponse>('/$_userType/$_id/choices', query: paramenters)
        .then(
      (value) {
        var response;

        // Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = (value.body!.data['choices'] as List<dynamic>)
              .map((e) => Choices.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        return response;
      },
    );
  }

  Future<String?> saveExistingChoice(
      {required String itemId, required List<dynamic> choiceList}) {
    var body = {"vendorId": _id, "itemId": itemId, "choices": choiceList};
    return post<ApiResponse>('/$_userType/$_id/choice/copy', body).then(
      (value) {
        var response;

        // Check for error
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

  Future<String?> updateMenuName(String menuId, String newName) {
    var body = {"name": newName};
    return put<ApiResponse>('/$_userType/$_id/menu/$menuId/edit-menu', body)
        .then(
      (value) {
        var response;

        // Check for error
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

  Future<String?> uploadMenuItem(DishMenu menu) {
    return post<ApiResponse>('/vendor/menu/add-item', addId(menu.toJson()))
        .then(
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

  Future<dynamic> uploadMenuName(String menuName) {
    var body = {"vendorId": _id, "name": menuName};
    return post<ApiResponse>('/vendor/menu', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          response = value.body!.data;
        }

        return response;
      },
    );
  }

  Future<String?> editMenuItem(DishMenuItem dish) {
    log(jsonEncode(addId(dish.toJson())));

    var body = {
      "name": dish.name,
      "originalPrice": dish.originalPrice,
      "discount": dish.discount,
      "prepTime": dish.prepTime,
      "categoryId": dish.categoryId!.id,
      "images": dish.images,
      "description": dish.description,
      "packPrice": dish.packPrice,
    };

    return put<ApiResponse>('/vendor/$_id/item/${dish.id}/edit-item', body)
        .then(
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

  Future<List<String>> customerReview() {
    return get<ApiResponse>('/$_userType/$_id/vendor-rating?vendorId=$_id')
        .then((value) {
      var response;

      //Check for error
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.message;
      }

      return response;
    });
  }

  Future<VendorProfile> fetchVendorProfile() {
    return get<ApiResponse>('/$_userType/$_id?_id=$_id').then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ vendor profile $response');
      }

      return VendorProfile.fromJson(response);
    });
  }

  Future<dynamic> payOrder(PayOrderModel payOrderModel) {
    var body = payOrderModel.toJson();
    return post<ApiResponse>('/$_userType/cart/order', body).then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        // return response;
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ customer profile $response');
      }

      return response;
    });
  }

  Future<dynamic> verifyOrderPayment(String paymentRef) {
    var body = {"customerId": _id, "reference": paymentRef};

    return post<ApiResponse>('/$_userType/cart/order/verify-payment', body)
        .then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        return response;
      } else {
        response = value.body!.message;
        debugPrint('+++++++ verify $response');
      }

      return response;
    });
  }

  Future<List<address.Address>?> fetchSavedAddress() {
    return get<ApiResponse>(
      '/$_userType/$_id/address',
    ).then((value) {
      var response;
      var addrs;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        if (value.body!.data.length == 0) {
          return null;
        }
        response = value.body!.data as List;

        addrs = response
            .map<address.Address>(
                (jsonData) => address.Address.fromJson(jsonData))
            .toList();
      }

      return addrs;
    });
  }

  final GoogleMapsPlaces googlePlaces =
      GoogleMapsPlaces(apiKey: googleMapsAPIKey);

  Future<List<AddressPrediction>> autocompleteAddress(String address) async {
    if (address.isEmpty) return Future.value([]);

    final result = await googlePlaces.autocomplete(address, region: 'ng');

    if (!result.isOkay) throw (result.errorMessage ?? result.status);

    if (result.hasNoResults) throw ('No results for search input');

    final predictions = result.predictions
        .map((prediction) => AddressPrediction(
            source: prediction,
            placeId: prediction.placeId,
            reference: prediction.reference,
            mainText: prediction.structuredFormatting!.mainText,
            subText: prediction.structuredFormatting!.secondaryText,
            formattedForDisplay: prediction.structuredFormatting!.mainText))
        .toList();

    return predictions;
  }

  Future<address.Address> detailsOfPlace(AddressPrediction place) async {
    final details = await googlePlaces
        .getDetailsByPlaceId(place.placeId!)
        .catchError((e) => throw Exception());

    if (!details.isOkay) throw (details.errorMessage!);

    if (details.hasNoResults)
      throw ('Failed to fetch details of selected location');

    final result = details.result;

    final response = _processAddressDetails(result);
    return response;
  }

  Future<address.Address> detailsOfLongLat(AddressPrediction place) async {
    final details = await googlePlaces
        .getDetailsByPlaceId(place.placeId!)
        .catchError((e) => throw Exception());

    if (!details.isOkay) throw (details.errorMessage!);

    if (details.hasNoResults)
      throw ('Failed to fetch details of selected location');

    final result = details.result;

    final response = _processAddressDetails(result);
    return response;
  }

  address.Address _processAddressDetails(result) {
    final addressData = address.Address(text: '', number: '2');
    addressData.long = result.geometry.location.lng.toString();
    addressData.lat = result.geometry.location.lat.toString();
    addressData.text = result.formattedAddress;
    // this number will chage to name very soon
    addressData.number = result.name;

    result.addressComponents.forEach(
      (component) {
        final List type = component.types;
        // if (type.contains('street_number')) {
        //   addressData.text = component.longName;
        // }
        // if (type.contains('route')) {
        //   addressData.text = component.longName;
        // }
        if (type.contains('locality') ||
            type.contains('administrative_area_level_2')) {
          addressData.locality = component.longName;
        }
        if (type.contains('locality') ||
            type.contains('administrative_area_level_1')) {
          addressData.state = component.longName;
        }
      },
    );
    return addressData;
  }

  Future<customer.OrderData> fetchSingleOrder(String trackingOrderID) {
    return get<ApiResponse>('/$_userType/$_id/orders?_id=$trackingOrderID')
        .then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ customer order $response');
      }

      return customer.OrderData.fromJson(response);
    });
  }

  Future<OrderReceipt> fetchOrderReceipt(String orderID) {
    final parameters = <String, dynamic>{
      'orderRef': orderID,
    };
    return get<ApiResponse>('/$_userType/$_id/order-receipt', query: parameters)
        .then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
      }

      return OrderReceipt.fromJson(response);
    });
  }

  Future<List<menu.Vendors>> searchMenu({String? query}) {
    final parameters = <String, dynamic>{
      'sort': 'asc',
      'limit': '15',
    };
    parameters.addIf(query?.isNotEmpty ?? false, 'searchWord', query);
    /* parameters.addIf(category?.isNotEmpty ?? false, 'category', category);
    parameters.addIf(
        deliveryTime?.isNotEmpty ?? false, 'deliveryTime', deliveryTime);
*/
    return get<ApiResponse>(
      '/$_userType/$_id/menu/search',
      query: parameters,
    ).then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = (value.body!.data['vendors'] as List<dynamic>)
            .map((e) => menu.Vendors.fromJson(e as Map<String, dynamic>))
            .toList();

        return response;
      }
    });
  }

  //customer/62e1148aa1a9e918fffd7339/orders?sort=asc&limit=20&skip=0'

  Future<VendorOrdersModel> fetchVendorOrders() {
    final parameters = <String, dynamic>{
      'vendorId': '$_id',
      'sort': 'desc',
    };
    return get<ApiResponse>('/$_userType/$_id/order', query: parameters)
        .then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ vendor orders $response');
      }

      return VendorOrdersModel.fromJson(response);
    });
  }

  Future<customer.OrderData> fetchOrders() {
    final parameters = <String, dynamic>{
      'customerId': _id,
      'sort': 'desc',
    };

    return get<ApiResponse>('/$_userType/$_id/orders', query: parameters)
        .then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.data;
        debugPrint('+++++++ customer orders $response');
      }

      return customer.OrderData.fromJson(response);
    });
  }

  Future<dynamic> reorderMenu(String orderId) {
    return get<ApiResponse>('/$_userType/$_id/order/$orderId/re-order')
        .then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.statusCode;
        debugPrint('+++++++ customer cart reorder $response');
      }

      return response;
    });
  }

  Future<dynamic> setDefaultAddress(address.Address address) {
    var body = {"address": address.toJson()};
    return put<ApiResponse>('/$_userType/$_id/profile', body).then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.message;
      }

      return response;
    });
  }

  Future<bool> deleteAddress(address.Address address) {
    return delete<ApiResponse>(
      '/$_userType/$_id/address/${address.id}',
    ).then((value) {
      var response;
      response = getErrorMessage(value);
      if (response != null) {
        throw (response);
      } else {
        response = value.body!.success;
      }

      return response;
    });
  }

  Future<RestaurantData> fetchVendor(String id) {
    return get<ApiResponse>('/$_userType/$_id/vendors?_id=$id').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = RestaurantData.fromJson(value.body!.data['vendors'][0]);
        }

        return response;
      },
    );
  }

  Future<dynamic> setNotification(bool notif) {
    var body = {"notifications": notif};
    return put<ApiResponse>('/$_userType/$_id/notifications', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<NotificationModel> getNotification() {
    final parameters = <String, dynamic>{
      'sort': 'desc',
      _userType == 'Customer' ? 'customerId' : 'vendorId': _id,
    };
    return get<ApiResponse>('/$_userType/$_id/notifications', query: parameters)
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return NotificationModel.fromJson(response);
      },
    );
  }

  Future<dynamic> setNotificationAsRead(String id) {
    return put<ApiResponse>('/$_userType/$_id/notifications/$id/read', '').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.success;
        }

        return response;
      },
    );
  }

  Future<dynamic> markAllNotifsAsRead() {
    return put<ApiResponse>('/$_userType/$_id/notifications/all-read', '').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.success;
        }

        return response;
      },
    );
  }

  Future<dynamic> clearAllNotifs() {
    return delete<ApiResponse>(
      '/$_userType/$_id/notifications/clear-notifications',
    ).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.success;
        }

        return response;
      },
    );
  }

  Future<dynamic> delNotification(String id) {
    return delete<ApiResponse>('/$_userType/$_id/notifications/$id/delete',
            contentType: '')
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.success;
        }

        return response;
      },
    );
  }

  Future<WalletModel> fetchWallet() {
    final parameters = <String, dynamic>{
      'vendorId': '$_id',
      'sort': 'asc',
    };
    return get<ApiResponse>('/$_userType/$_id/wallet', query: parameters).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data[0];
        }

        return WalletModel.fromJson(response);
      },
    );
  }

  Future<List<Transaction>> fetchTransaction() {
    final parameters = <String, dynamic>{
      'sort': 'desc',
    };
    return get<ApiResponse>('/$_userType/$_id/transactions', query: parameters)
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = (value.body!.data['transactions'] as List<dynamic>)
              .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        return response;
      },
    );
  }

  Future<Sales> fetchSales() {
    final parameters = <String, dynamic>{
      'sort': 'desc',
    };
    return get<ApiResponse>('/$_userType/$_id/sales', query: parameters).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = (value.body!.data['sales'] as List<dynamic>)
              .map((e) => Sale.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        return response;
      },
    );
  }

  /*  Future<List<Transactions>> fetchEarnings() {
    final parameters = <String, dynamic>{
      'sort': 'asc',
    };
    return get<ApiResponse>('/$_userType/$_id/sales', query: parameters)
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = (value.body!.data['transactions'] as List<dynamic>)
              .map((e) => Transactions.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        return response;
      },
    );
  }
 */
  Future<String?> confirmOrder(String orderId) {
    return put<ApiResponse>('/$_userType/$_id/order/$orderId/confirm', '').then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> rejectOrder(String orderId) {
    return put<ApiResponse>('/$_userType/$_id/order/$orderId/reject', '').then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> cancelOrder(String orderId) {
    return put<ApiResponse>('/$_userType/$_id/order/$orderId/cancel', '').then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> setOrderAwaitingPickup(String orderId) {
    return put<ApiResponse>(
            '/$_userType/$_id/order/$orderId/awaiting-pickup', '')
        .then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> completeOrder(String orderId) {
    return put<ApiResponse>('/$_userType/$_id/order/$orderId/complete', '')
        .then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> updateProfile(
      String name, String email, String phone, String profileImage) {
    final body = <String, dynamic>{
      _userType == 'customer' ? "name" : "vendorName": name,
      "email": email,
      "phone": phone,
    };
    body.addIf(profileImage.isNotEmpty, 'image', profileImage);
    /* var body = {
      _userType == 'customer' ? "name" : "vendorName": name,
      "email": email,
      "phone": phone,
      profileImage != ''?"image": profileImage : ''
    };*/
    String endpoint = _userType == 'customer'
        ? '/$_userType/$_id/profile'
        : '/$_userType/$_id/restaurant-profile/edit';
    return put<ApiResponse>(endpoint, body).then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> uploadToken(String token) {
    var body = {
      "deviceToken": token,
    };
    String endpoint = _userType == 'customer'
        ? '/$_userType/$_id/profile'
        : '/$_userType/$_id/restaurant-profile/edit';
    return put<ApiResponse>(endpoint, body).then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<dynamic> setShopStatus(bool status) {
    var body = {"open": status};
    return put<ApiResponse>('/$_userType/$_id/open', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<dynamic> setPickUpStatus(bool status) {
    var body = {"pickup": status};
    return put<ApiResponse>('/$_userType/$_id/pickup-status', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<dynamic> setOpeningHours(Map<String, dynamic> openingHours) {
    var body = openingHours;
    return put<ApiResponse>('/$_userType/$_id/restaurant-operating-hours', body)
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> setWithdrawalPin(
    String oldPin,
    String newPin,
  ) {
    var body = {"oldPin": oldPin, "newPin": newPin};
    return put<ApiResponse>('/$_userType/$_id/wallet/pin', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> withdrawMoney(String vendorId, String amount, String pin) {
    var body = {"vendorId": vendorId, "amount": amount, "pin": pin};
    return post<ApiResponse>('/wallet/withdrawal', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> addMenuToFav(String menuId) {
    return put<ApiResponse>('/$_userType/$_id/menu-item/$menuId/like', '').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> removeMenuFromFav(String menuId) {
    return put<ApiResponse>('/$_userType/$_id/menu-item/$menuId/dislike', '')
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<FavouriteMenuModel> fetchFavMenus() {
    final parameters = <String, dynamic>{
      'sort': 'asc',
      'limit': '0',
      'skip': '0'
    };

    return get<ApiResponse>('/$_userType/$_id/favourite-menu-items',
            query: parameters)
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return FavouriteMenuModel.fromJson(response);
      },
    );
  }

  Future<dynamic> setMenu(String id, bool menu) {
    var body = {"available": menu};

    return put<ApiResponse>('/$_userType/$_id/item/$id/edit-item', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<dynamic> rateVendor(String orderId, String? review, double rate) {
    var body = {
      "orderId": orderId,
      "customerId": '$_id',
      "rating": rate.toInt(),
      "review": review
    };

    return post<ApiResponse>('/$_userType/vendor-rating', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<dynamic> rateRider(String orderId, String review, double rate) {
    var body = {
      "orderId": orderId,
      "customerId": '$_id',
      "rating": rate,
      "review": review
    };

    return post<ApiResponse>('/$_userType/rider-rating', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<CustomerReviewModel> fetchVendorReview() {
    var params = {
      "vendorId": _id,
    };
    return get<ApiResponse>('/$_userType/$_id/vendor-rating', query: params)
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return CustomerReviewModel.fromJson(response);
      },
    );
  }

  Future<List<HomeCategory>> fetchHomePageDetails() {
    if (AppRepository.userIsGuest && _address == null) {
      throw ('No address detected');
    }

    final url = '/$_userType/$_id/homepage-summary';

    return get<ApiResponse>(url).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // Send response
          response = [
            HomeCategory(
              'All Restaurants',
              CategoryType.restaurants,
              (value.body?.data['allVendors'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
            HomeCategory(
              'Near You',
              CategoryType.restaurants,
              (value.body?.data['nearbyVendors'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
            // value.body?.data['cartItems']
            HomeCategory(
              'Pocket Friendly',
              CategoryType.restaurants,
              (value.body?.data['pocketFriendlyMenus'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),

            HomeCategory(
              'Discount Offers',
              CategoryType.discountOffers,
              (value.body?.data['discountedMenus'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.discountdDishes,
                        discountedDishes: DiscountedDishes.fromJson(
                            e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),

            /*  HomeCategory('Popular Dishes', CategoryType.popularDishes, []
                (value.body?.data['popular_dishes'] as List<dynamic>)
                    .map((e) => HomeItem(
                          HomeItemType.dish,
                          dish: Dish.fromJson(e as Map<String, dynamic>),
                        ))
                    .toList(),
                ), */
          ];
        }

        return response;
      },
    );
  }

  Future<List<HomeCategory>> fetchNearbyVendors() {
    return get<ApiResponse>('/$_userType/$_id/nearby-vendors').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // Send response
          response = [
            HomeCategory(
              'Near You',
              CategoryType.restaurants,
              (value.body?.data['vendors'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
          ];
        }

        return response;
      },
    );
  }

  Future<List<HomeCategory>> fetchAllVendors() {
    return get<ApiResponse>('/$_userType/$_id/all-vendors').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // Send response
          response = [
            HomeCategory(
              'All Restaurants',
              CategoryType.restaurants,
              (value.body?.data['vendors'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
          ];
        }

        return response;
      },
    );
  }

  Future<List<HomeCategory>> fetchNewlyAdded() {
    return get<ApiResponse>('/$_userType/$_id/newly-added-vendors').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // Send response
          response = [
            HomeCategory(
              'Newly Added',
              CategoryType.restaurants,
              (value.body?.data['vendors'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
          ];
        }

        return response;
      },
    );
  }

  Future<List<HomeCategory>> fetchTrendingVendors() {
    return get<ApiResponse>('/$_userType/$_id/trending-vendors').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // Send response
          response = [
            HomeCategory(
              'Trending Now',
              CategoryType.restaurants,
              (value.body?.data['vendors'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
          ];
        }

        return response;
      },
    );
  }

  Future<List<HomeCategory>> fetchDiscountedDishes() {
    return get<ApiResponse>('/$_userType/$_id/discounted-menus?sort=desc').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          print('I REACH HERE: ${value.body?.data}');
          final items = (value.body?.data['vendors'] as List<dynamic>).map((e) {
            //print("discount item is $e");
            final menu = DiscountedDishes.fromJson(e as Map<String, dynamic>);
            //print("dish list is ${menu.menuItems!.length}");
            return HomeItem(HomeItemType.discountdDishes,
                discountedDishes: menu);
          }).toList();
          print("items of vendors is ${items.length}");
          // Send response
          response = [
            HomeCategory('Discount Offers', CategoryType.discountOffers, items),
          ];
        }

        return response;
      },
    );
  }

  Future<List<HomeCategory>> fetchDiscounts() {
    return get<ApiResponse>('/$_userType/$_id/discounted-menus?sort=desc').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // Send response
          response = [
            HomeCategory(
              'Discount Offers',
              CategoryType.discountOffers,
              (value.body?.data['menus'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.dish,
                        dish: DishMenu.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
          ];
        }

        return response;
      },
    );
  }

  Future<String> suggestRestaurant(
      String restaurantName, String restaurantLocation) {
    var body = {
      "customerId": _id,
      "restaurantName": restaurantName,
      "restaurantLocation": restaurantLocation
    };
    return post<ApiResponse>('/$_userType/$_id/suggest-restaurant', body).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  // Fetch Nearby
  Future<List<HomeCategory>> fetchPocketFriendly() {
    return get<ApiResponse>('/$_userType/$_id/pocket-friendly-items?sort=desc')
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // if (response != null) {
          //   throw (response);
          // } else {
          // Send response
          response = [
            HomeCategory(
              'Pocket Friendly',
              CategoryType.pocketFriendly,
              (value.body?.data['vendors'] as List<dynamic>)
                  .map((e) => HomeItem(
                        HomeItemType.restaurant,
                        restaurant:
                            Restaurant.fromJson(e as Map<String, dynamic>),
                      ))
                  .toList(),
            ),
          ];
        }

        return response;
      },
    );
  } // Fetch Nearby

  Future<List<Vouchers>> fetchVouchers() {
    return get<ApiResponse>('/$_userType/$_id/homepage-summary').then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          if (response is String && response.contains('address')) {
            return [];
          } else {
            throw (response);
          }
        } else {
          // if (response != null) {
          //   throw (response);
          // } else {
          // Send response
          response = (value.body?.data['activeVoucherOffers'] as List<dynamic>)
              .map(((e) => Vouchers.fromJson(e as Map<String, dynamic>)))
              .toList();

          // final voucher =
          //     List.from(response).map((e) => VoucherModel.fromJson(e)).toList();
        }

        return response;
      },
    );
  }

  Future<ConversationModel?> fetchConversation() {
    final parameters = <String, dynamic>{
      'userId': _id,
      'sort': 'asc',
    };

    return get<ApiResponse>('/$_userType/$_id/chat-conversations',
            query: parameters)
        .then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return ConversationModel.fromJson(response);
      },
    );
  }

  Future<ChatMessageModel?> fetchChatMessage(String riderId) {
    final parameters = <String, dynamic>{
      'userId': _id,
      'riderId': riderId,
      'sort': 'asc',
    };

    return get<ApiResponse>('/$_userType/$_id/chat-messages', query: parameters)
        .then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.data;
        }

        return ChatMessageModel.fromJson(response);
      },
    );
  }

  Future<String?> markAsRead(String chatId) {
    return put<ApiResponse>('/$_userType/$_id/conversation/$chatId/read', '')
        .then(
      (value) {
        var response;
        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // Send response
          response = value.body!.message;
        }

        return response;
      },
    );
  }

  Future<String?> uploadImage(String path) {
    final name = path.split('/').last;
    final FormData formData = FormData({
      'image': MultipartFile(path, filename: name),
    });

    return post<ApiResponse>('/convert-image', formData).then(
      (value) {
        var response;

        //Check for error
        response = getErrorMessage(value);
        if (response != null) {
          throw (response);
        } else {
          // return URL
          response = value.body?.data['image'];
        }
        return response;
      },
    );
  }

  Future<String?> deleteAccount(
    String reason,
  ) {
    var body = {
      _userType == 'customer' ? "customerId" : "vendorId": _id,
      "reason": reason,
    };
    return post<ApiResponse>('/$_userType/delete-account', body).then(
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

  Map addId(Map data) {
    final Map<String, dynamic> dat = Map.from(data);
    dat.addAll({"vendorId": _id});
    return dat;
  }
}

String? getErrorMessage(Response<ApiResponse> response) {
  if (kDebugMode && printResponses) {
    log(' Status Code: ${response.statusCode}');
    log(' Status Text: ${response.statusText}');
    log(' Response Body: ${response.bodyString}');
    log('Headers: ${response.request?.headers.toString()}');
    log(' URL: ${response.request?.url}');
  }

  if (response.statusCode != null &&
      response.isOk &&
      (response.body!.success == true || response.body!.error == false)) {
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
 */