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

//auction
  addAuctionItem(String detailes) async {
    final response = await dio.post("${url}addAuctionItem", data: detailes);
    return response;
  }

  getAuctionByShopid(String shopid) async {
    final response =
        await dio.post("${url}getAuctionByShopid", data: {"shopid": shopid});
    return response;
  }

  getAuctionById(String auctionid) async {
    final response =
        await dio.post("${url}getAuctionById", data: {"auctionid": auctionid});
    return response;
  }

  deleteAuctionById(String auctionid) async {
    final response = await dio
        .post("${url}deleteAuctionById", data: {"auctionid": auctionid});
    return response;
  }

  updateAuctionStatus(String auctionid, String status) async {
    final response = await dio.post("${url}updateAuctionStatus",
        data: {"auctionid": auctionid, "status": status});
    return response;
  }

  getAllAuction() async {
    final response = await dio.post("${url}getAllAuction", data: {});
    return response;
  }

  getHighestBidByAuctionId(String auctionid) async {
    final response = await dio
        .post("${url}getHighestBidByAuctionId", data: {"auctionid": auctionid});
    return response;
  }
}
