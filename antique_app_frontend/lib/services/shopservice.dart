import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShopService {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url = "http://10.0.2.2:3000/api/";
  getNotApprovedShop() async {
    final response = await dio.post("${url}getnot-approved-shops");
    return response;
  }

  getShopById(shopid) async {
    final response =
        await dio.post("${url}getshop-by-id", data: {"shopid": shopid});
    return response;
  }

  approveShop(shopid) async {
    final response =
        await dio.post("${url}approve-shops", data: {"shopid": shopid});
    return response;
  }

  rejectShop(shopid) async {
    final response =
        await dio.post("${url}reject-shops", data: {"shopid": shopid});
    return response;
  }

  getAllCategory() async {
    final response = await dio.post("${url}get-all-category");
    return response;
  }

  getSubCategory(String categoryid) async {
    final response = await dio
        .post("${url}get-all-subcategory", data: {"categoryid": categoryid});
    return response;
  }

  addProduct(String products) async {
    final response = await dio.post("${url}addproduct", data: products);
    return response;
  }

  getShopByUserId(String userid) async {
    final response =
        await dio.post("${url}getshop-by-userid", data: {"userid": userid});
    return response;
  }
}
