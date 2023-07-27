import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductService {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url = "http://10.0.2.2:3000/api/";

  getProductsByShopId(String shopid) async {
    final response =
        await dio.post("${url}getproduct-by-shopid", data: {"shopid": shopid});
    return response;
  }

  getProductByProductid(String productid) async {
    final response = await dio
        .post("${url}getproduct-by-id", data: {"productid": productid});
    return response;
  }

  updateProductPrice(String productid, String price) async {
    final response = await dio.post("${url}updateproduct-price",
        data: {"productid": productid, "price": price});
    return response;
  }

  updateProductDiscount(String productid, String discount_percentage) async {
    final response = await dio.post("${url}updateproduct-discount", data: {
      "productid": productid,
      "discount_percentage": discount_percentage
    });
    return response;
  }

  updateProductAvailability(String productid, String availability) async {
    final response = await dio.post("${url}updateproduct-availability",
        data: {"productid": productid, "availability": availability});
    return response;
  }

  updateProductStock(String productid, String stock) async {
    final response = await dio.post("${url}updateproduct-stock",
        data: {"productid": productid, "stock": stock});
    return response;
  }
}
