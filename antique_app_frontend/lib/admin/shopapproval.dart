import 'dart:convert';

import 'package:antique_app/admin/viewshop.dart';
import 'package:antique_app/services/shopservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShopApproval extends StatefulWidget {
  const ShopApproval({super.key});

  @override
  State<ShopApproval> createState() => _ShopApprovalState();
}

class _ShopApprovalState extends State<ShopApproval> {
  ShopService service=ShopService();
  List<dynamic> _data = [];
  bool _isLoading = false;
  Future<void>getShops()async {
     setState(() {
      _isLoading = true;
    });
    try{
     final Response? response=await service.getNotApprovedShop();
     print(response!.data);
     setState(() {
       _data=response.data;
       _isLoading=false;
     });
    }on DioException catch(e){
      print(e.error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("admin shop");
    getShops();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _isLoading?const Center(child: CircularProgressIndicator(),)
    :ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context,index){
          return ListTile(
            leading:const Icon(Icons.shop,size: 30,color: Colors.blue,) ,
            title: Text(_data[index]["shopname"],style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
            subtitle: Text(_data[index]["shopdistrict"]),
            onTap: (){
               Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ViewShop(shopid:_data[index]["_id"])),
  );
            },
          );
    }));
  }
}