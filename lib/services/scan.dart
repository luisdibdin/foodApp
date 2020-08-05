import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:food_app/services/database.dart';

class Scan {

  var barcode;
  static Product foodItem;
  String productName;
  double productCalories;
  double productCarbs;
  double productFat;
  double productProtein;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future barcodeScan() async {
    ScanResult scanResult = await BarcodeScanner.scan();
    barcode = scanResult.rawContent;
    foodItem = await getProduct(barcode);
    storeProduct(foodItem);
    return productName;
  }

  Future storeProduct(Product foodItem) async {
    productName = foodItem.productName;
    productCalories = foodItem.nutriments.energyKcal;
    productCarbs = foodItem.nutriments.carbohydrates;
    productFat = foodItem.nutriments.fat;
    productProtein = foodItem.nutriments.proteins;
    final FirebaseUser user = await _auth.currentUser();
    await DatabaseService(uid: user.uid).newScanData(productName, productCalories, productCarbs, productFat, productProtein);
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
