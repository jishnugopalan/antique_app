import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrderService {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url = "http://10.0.2.2:3000/api/";

  getOrderByCustomerID(String userid) async {
    final response =
        await dio.post("${url}getorder-by-userid", data: {"userid": userid});
    return response;
  }

  getOrderByShopID(String shopid) async {
    final response =
        await dio.post("${url}getorder-by-shopid", data: {"shopid": shopid});
    return response;
  }

  getOrderById(String orderid) async {
    final response =
        await dio.post("${url}getorder-by-id", data: {"orderid": orderid});
    return response;
  }

  cancelorder(String orderid) async {
    final response =
        await dio.post("${url}cancelorder", data: {"orderid": orderid});
    return response;
  }

  updateorderstatus(String orderid, String status) async {
    final response = await dio.post("${url}updateorderstatus",
        data: {"orderid": orderid, "status": status});
    return response;
  }
}
