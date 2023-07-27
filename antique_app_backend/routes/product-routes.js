var express = require('express'),
routes = express.Router()
const categoryController=require("../controller/category-controller")
const productController=require("../controller/product-controller")

//category routes
routes.post("/add-category",categoryController.addCategory)
routes.post("/add-subcategory",categoryController.addSubcategory)
routes.post("/get-all-category",categoryController.getAllCategory)
routes.post("/get-all-subcategory",categoryController.getAllSubcategory)

//product routes
routes.post("/addproduct",productController.addProduct)
routes.post("/getproduct-by-shopid",productController.getProductByShopId)
routes.post("/getproduct-by-category",productController.getProductByCategory)
routes.post("/getproduct-by-subcategory",productController.getProductBySubCategory)
routes.post("/getproduct-by-id",productController.getProductById)
routes.post("/getallproduct",productController.getAllProducts)
routes.post("/updateproduct-price",productController.updateProductPrice)
routes.post("/updateproduct-discount",productController.updateProductDiscount)
routes.post("/updateproduct-availability",productController.updateProductAvailability)
routes.post("/updateproduct-stock",productController.updateProductStock)

routes.post("/addtocart",productController.addToCart)
routes.post("/getcart-by-userid",productController.getCartByUser)
routes.post("/delete-cart",productController.deleteCartProduct)

module.exports = routes