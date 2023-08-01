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

  getProductBySubCategory(String subcategoryid) async {
    final response = await dio.post("${url}getproduct-by-subcategory",
        data: {"subcategoryid": subcategoryid});
    return response;
  }

  addToCart(String cart) async {
    final response = await dio.post("${url}addtocart", data: cart);
    return response;
  }

  getCartById(String userid) async {
    final response =
        await dio.post("${url}getcart-by-userid", data: {"userid": userid});
    return response;
  }

  deleteCartItem(String cartid) async {
    final response =
        await dio.post("${url}delete-cart", data: {"cartid": cartid});
    return response;
  }

  addShippingAddress(String address) async {
    final response =
        await dio.post("${url}add-shipping-address", data: address);
    return response;
  }

  startOrder(String orderdata) async {
    final response = await dio.post("${url}createorder", data: orderdata);
    return response;
  }

  startPayment(String paymentdata) async {
    final response = await dio.post("${url}startpayment", data: paymentdata);
    return response;
  }

  decreaseStock(String productid, int qty) async {
    final response = await dio
        .post("${url}decreasestock", data: {"product": productid, "qty": qty});
    return response;
  }

  deleteAllCartItems(String userid) async {
    final response =
        await dio.post("${url}deleteallcartitems", data: {"userid": userid});
    return response;
  }

  getOrderById(String orderid) async {
    final response =
        await dio.post("${url}getorder-by-id", data: {"orderid": orderid});
    return response;
  }

  updateOrderStatus(String orderid, String status) async {
    final response = await dio.post("${url}updateorderstatus",
        data: {"orderid": orderid, "status": status});
    return response;
  }
}
