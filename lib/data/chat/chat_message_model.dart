import 'package:bibuain_pay/data/bank/bank.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

/// chats : [{"_id":"631af778c5cfd216be94b730","riderId":"6317c9c382d45183e44e6aa2","user":"Customer","userId":"62e1148aa1a9e918fffd7339","conversationId":"631af778c5cfd216be94b72e","sender":"Rider","message":"Hello, i'm at your gate for delivery","createdAt":"2022-09-09T08:21:12.412Z","updatedAt":"2022-09-09T08:21:12.412Z","__v":0},{"_id":"631af80ac5cfd216be94b734","riderId":"6317c9c382d45183e44e6aa2","user":"Customer","userId":"62e1148aa1a9e918fffd7339","conversationId":"631af778c5cfd216be94b72e","sender":"User","message":"alright, will meet you.","createdAt":"2022-09-09T08:23:38.649Z","updatedAt":"2022-09-09T08:23:38.649Z","__v":0}]
/* 
class ChatMessageModel {
  ChatMessageModel({
    this.chats,
  });

  ChatMessageModel.fromJson(dynamic json) {
    if (json['chats'] != null) {
      chats = [];
      json['chats'].forEach((v) {
        chats?.add(Chats.fromJson(v));
      });
    }
  }

  List<Chats>? chats;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chats != null) {
      map['chats'] = chats?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
 */
/// _id : "631af778c5cfd216be94b730"
/// riderId : "6317c9c382d45183e44e6aa2"
/// user : "Customer"
/// userId : "62e1148aa1a9e918fffd7339"
/// conversationId : "631af778c5cfd216be94b72e"
/// sender : "Rider"
/// message : "Hello, i'm at your gate for delivery"
/// createdAt : "2022-09-09T08:21:12.412Z"
/// updatedAt : "2022-09-09T08:21:12.412Z"
/// __v : 0

class Chats {
  Chats({
    required this.amount,
    required this.senderName,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  double amount;
  String senderName;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['conversationId'] = amount;
    map['sender'] = senderName;
    map['message'] = description;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}

typedef Transactions = List<Transaction>;

@JsonSerializable()
class Transaction {
  Transaction({
    required this.amount,
    required this.senderName,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.bank,
  });

  final double amount;
  final String senderName;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Bank bank;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
