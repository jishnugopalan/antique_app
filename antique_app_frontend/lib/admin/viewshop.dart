import 'dart:convert';

import 'package:antique_app/admin/successmsg.dart';
import 'package:antique_app/services/shopservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../widgets/text_widgets.dart';

class ViewShop extends StatefulWidget {
  const ViewShop({super.key, required this.shopid});
  final String shopid;

  @override
  State<ViewShop> createState() => _ViewShopState();
}

class _ViewShopState extends State<ViewShop> {
  ShopService service=ShopService();
  dynamic _data;
  bool _isLoading = false;
  Future<void>approveShop(shopid)async{
    try{
     final Response response=await service.approveShop(shopid);
     print(response.data);
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => ShopApproveSuccess(message: 'Shop Approved Successfully',)));
    }on DioException catch(e){
      print(e.error);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Error occurred,please try again"),
                duration: Duration(milliseconds: 300),
              ));
    }
  }
  Future<void>rejectShop(shopid)async{
    try{
     final Response response=await service.rejectShop(shopid);
     print(response.data);
    // Navigator.of(context).pushReplacementNamed('/adminapprove_msg');
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => ShopApproveSuccess(message: 'Shop Rejected Successfully',)));
    }on DioException catch(e){
      print(e.error);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Error occurred,please try again"),
                duration: Duration(milliseconds: 300),
              ));
    }
  }
  Future<void>getShopById()async {
    setState(() {
      _isLoading=true;
    });
    try{
      final Response response=await service.getShopById(widget.shopid);
      print(response.data);
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
    print(widget.shopid);
    getShopById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Approve Shop")),
      body: _isLoading?Center(child: CircularProgressIndicator(),):ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
          child: Text.rich(
        TextSpan(
          //text: 'Hello', // default text style
          children: <TextSpan>[
            TextSpan(text: "Shop Details"+"\n",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.deepPurple)),
            TextSpan(text: _data["shopname"]+"\n",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color.fromARGB(255, 1, 108, 5))),
            TextSpan(text: "District: "+_data["shopdistrict"]+"\n",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            TextSpan(text: "City: "+_data["shopcity"]+"\n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            TextSpan(text: "Pincode: "+_data["shoppincode"]+"\n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            TextSpan(text: "Shop phone: "+_data["shopphone"].toString()+"\n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            TextSpan(text: "Shop email: "+_data["shopemail"]+"\n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),

            TextSpan(text: "\nOwner Details"+"\n",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.deepPurple)),
            TextSpan(text: _data["user"]["name"]+"\n",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color.fromARGB(255, 1, 108, 5))),
            TextSpan(text: "Email: "+_data["user"]["email"]+"\n",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            TextSpan(text: "Phone: "+_data["user"]["phone"].toString()+"\n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),

            TextSpan(text: "\nShop License"+"\n",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.deepPurple)),


          ],
        ),),
        ),
        Image.memory(
                    base64Decode(_data['shoplicense'].split(',')[1]),
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Icon(Icons.image);
                    },
                  ),
        ElevatedButton(onPressed:(){
          approveShop(_data["_id"]);
        }, child:const Text("Submit")),
        ElevatedButton(onPressed:(){
          rejectShop(_data["_id"]);
        }, child:const Text("Reject"),style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),

        
        ],
      )
    );
  }
}
