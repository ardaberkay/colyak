import 'dart:typed_data';

import 'package:colyak/models/nutritionalvalueslist_model.dart';

class Receipt {
  int? id;
  String? receiptName;
  String? createdDate;
  List<String>? receiptDetails;
  List<ReceiptItems>? receiptItems;
  List<NutritionalValuesList>? nutritionalValuesList;
  int? imageId;
  String? imageData;
  bool? deleted;
  String? imageUrl;
  Uint8List? imageBytes;

  Receipt({
    this.id,
    this.receiptName,
    this.createdDate,
    this.receiptDetails,
    this.receiptItems,
    this.nutritionalValuesList,
    this.imageId,
    this.imageData,
    this.deleted,
    this.imageUrl,
    this.imageBytes
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      receiptName: json['receiptName'],
      createdDate: json['createdDate'],
      imageUrl: json['imageUrl'],
      receiptDetails: List<String>.from(json['receiptDetails']),
      receiptItems: (json['receiptItems'] as List<dynamic>?)
          ?.map((item) => ReceiptItems.fromJson(item))
          .toList(),
      nutritionalValuesList: (json['nutritionalValuesList'] as List<dynamic>?)
          ?.map((item) => NutritionalValuesList.fromJson(item))
          .toList(),
      imageId: json['imageId'],
      deleted: json['deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiptName': receiptName,
      'createdDate': createdDate,
      'receiptDetails': receiptDetails,
      'receiptItems': receiptItems?.map((item) => item.toJson()).toList(),
      'nutritionalValuesList': nutritionalValuesList?.map((item) => item.toJson()).toList(),
      'imageId': imageId,
      'imageUrl': imageUrl,
      'deleted': deleted,
    };
  }
}


class ReceiptItems {
  int? id;
  String? productName;
  double? unit;
  String? type;

  ReceiptItems({this.id, this.productName, this.unit, this.type});

  factory ReceiptItems.fromJson(Map<String, dynamic> json) {
    return ReceiptItems(
      id: json['id'],
      productName: json['productName'],
      unit: json['unit'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'unit': unit,
      'type': type,
    };
  }
}
