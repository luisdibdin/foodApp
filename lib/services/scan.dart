import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:food_app/services/database.dart';

class Scan {

  var barcode;
  static Product foodItem;
  String productName;
  String productID;
  double productCalories;
  double productCarbs;
  double productFat;
  double productProtein;
  Timestamp dateTime;
  double grams;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Scan({this.productID, this.productName, this.productCalories, this.productCarbs, this.productFat, this.productProtein, this.dateTime, this.grams});

  Future barcodeScan() async {
    ScanResult scanResult = await BarcodeScanner.scan();
    barcode = scanResult.rawContent;
    foodItem = await getProduct(barcode);
    return foodItem;
  }

  Future storeProduct(Product foodItem, double servingSize, String servingType) async {
    productName = foodItem.productName;
    print(foodItem.environmentImpactLevels);
    double servingSizeGrams = servingSize/100;
    if (servingType == 'grams') {
      productCalories = foodItem.nutriments.energyKcal100g * servingSizeGrams;
      productCarbs = foodItem.nutriments.carbohydrates * servingSizeGrams;
      productFat = foodItem.nutriments.fat * servingSizeGrams;
      productProtein = foodItem.nutriments.proteins * servingSizeGrams;
      grams = servingSize;
    } else {
      productCalories = foodItem.nutriments.energyKcal * servingSize;
      productCarbs = foodItem.nutriments.carbohydratesServing * servingSize;
      productFat = foodItem.nutriments.fatServing * servingSize;
      productProtein = foodItem.nutriments.proteinsServing * servingSize;
      grams = servingSize * foodItem.servingQuantity;
    }
    final FirebaseUser user = await _auth.currentUser();
    await DatabaseService(uid: user.uid).newScanData(productName, productCalories, productCarbs, productFat, productProtein, grams);
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
