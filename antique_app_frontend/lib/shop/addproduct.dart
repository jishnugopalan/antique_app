import 'dart:convert';
import 'dart:io';

import 'package:antique_app/services/shopservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  ShopService service = ShopService();
  final _formKey = GlobalKey<FormState>();
  String? dropdownValue = null;
  String? dropdownValue2 = null;
  String? productname,
      description,
      price,
      stock,
      availabilirt,
      discount_percentage;
  String? categoryid, subcategoryid;
  List<String> category = <String>[];
  List<String> subcategory = <String>[];
  XFile? _imageFile;
  late Response? response;
  late Response? response2;
  final storage = const FlutterSecureStorage();
  bool isLoading = false;

  Future<void> getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> getCategory() async {
    try {
      response = await service.getAllCategory();
      print(response!.data);
      final jsonData = response!.data;

      for (int i = 0; i < jsonData.length; i++) {
        setState(() {
          category.add(jsonData[i]["category"]);
        });
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  Future<void> getSubcategory() async {
    final jsonData = response!.data;
    String c = "";

    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i]["category"] == dropdownValue) {
        c = jsonData[i]["_id"];
        setState(() {
          categoryid = jsonData[i]["_id"];
        });
        break;
      }
    }

    try {
      response2 = await service.getSubCategory(c);
      print(response2!.data);
      final jsonData2 = response2!.data;
      subcategory.clear();
      for (int i = 0; i < jsonData2.length; i++) {
        setState(() {
          subcategory.add(jsonData2[i]["subcategory"]);
        });
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  getSubcategoryId() {
    final jsonData = response2!.data;
    String c = "";

    print(jsonData);
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i]["subcategory"] == dropdownValue2) {
        c = jsonData[i]["_id"];
        //print(c);
        setState(() {
          subcategoryid = jsonData[i]["_id"];
        });
        break;
      }
    }
  }

  Future<void> addProduct() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    String shopid = "";
    try {
      final Response? response3 = await service.getShopByUserId(userid!);
      shopid = response3!.data["_id"];
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
    print(shopid);
    List<String>? s = _imageFile?.path.toString().split("/");
    final bytes = await File(_imageFile!.path).readAsBytes();
    final base64 = base64Encode(bytes);
    var pic =
        "data:image/" + s![s.length - 1].split(".")[1] + ";base64," + base64;
    var product = jsonEncode({
      "shop": shopid,
      "productname": productname,
      "category": categoryid,
      "subcategory": subcategoryid,
      "price": price,
      "stock": stock,
      "image": pic,
      "description": description,
      "discount_percentage": discount_percentage
    });
    print(product);
    try {
      final Response? response4 = await service.addProduct(product);
      print(response4);
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Product Added"),
              content: Text("$productname added successfully"),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } on DioException catch (e) {
      if (e.response != null) {
        setState(() {
          isLoading = false;
        });
        print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      } else {
        setState(() {
          isLoading = false;
        });
        // Something happened in setting up or sending the request that triggered an Error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Products"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(20),
                //   child: const Text(
                //     "Add Products",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              const Text("Select Product image"),
                              IconButton(
                                  onPressed: getImageFromCamera,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  )),
                              IconButton(
                                  onPressed: getImageFromGallery,
                                  icon: const Icon(
                                    Icons.image,
                                    color: Colors.blue,
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          child: Card(
                            child: _imageFile == null
                                ? const Text('No image selected ')
                                : Image.file(
                                    File(_imageFile!.path),
                                    width: 360,
                                    height: 240,
                                  ),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Product Name",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Name is required";
                              } else if (value.length < 2) {
                                return "Name should contain more than two characters";
                              }
                              setState(() {
                                productname = value;
                              });
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: DropdownButton(
                            hint: const Text("Select Item Category"),
                            value: dropdownValue,
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                              getSubcategory();
                            },
                            items: category
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: DropdownButton(
                            hint: const Text("Select Sub  Category"),
                            value: dropdownValue2,
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue2 = newValue!;
                              });
                              getSubcategoryId();
                            },
                            items: subcategory
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          height: 80,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Product Description",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Description is required";
                              } else if (value.length < 5) {
                                return "Description should contain more than five characters";
                              }
                              setState(() {
                                description = value;
                              });
                              return null;
                            },
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Price",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Price is required";
                              } else if (int.parse(value) <= 0) {
                                return "Please enter a valid price";
                              }
                              setState(() {
                                price = value;
                              });
                              return null;
                            },
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Discount Percentage",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Discount Percentage is required";
                              } else if (int.parse(value) <= 0) {
                                return "Please enter a valid percentage";
                              }
                              setState(() {
                                discount_percentage = value;
                              });
                              return null;
                            },
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Stock",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Stock is required";
                              } else if (int.parse(value) <= 0) {
                                return "Please enter a valid stock count";
                              }
                              setState(() {
                                stock = value;
                              });
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: SizedBox(
                          width: 400,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text("Add"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //();
                                addProduct();
                              }
                            },
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
