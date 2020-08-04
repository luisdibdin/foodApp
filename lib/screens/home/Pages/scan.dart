import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class Scan {

  var barcode;
  static Product foodItem;
  static String productName;

  Future barcodeScan() async {
    ScanResult scanResult = await BarcodeScanner.scan();
    barcode = scanResult.rawContent;
    foodItem = await getProduct(barcode);
    productName = foodItem.productName;
    return productName;
  }

  Future<Product> getProduct(String barcode) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode, language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result =
    await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      return result.product;
    } else {
      throw new Exception("product not found, please insert data for " + barcode);
    }
  }
}
