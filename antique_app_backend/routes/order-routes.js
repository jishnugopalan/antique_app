var express = require('express'),
routes = express.Router()
const orderController=require("../controller/order-controller")
routes.post("/createorder",orderController.createOrder)
routes.post("/getorder-by-id",orderController.getOrderById)
routes.post("/getorder-by-shopid",orderController.getOrderByShopId)
routes.post("/getorder-by-userid",orderController.getOrderByUserid)
routes.post("/cancelorder",orderController.cancelOrder)
routes.post("/startpayment",orderController.startPayment)
routes.post("/decreasestock",orderController.decreaseProductsStock)
routes.post("/deleteallcartitems",orderController.deleteAllItemFromCart)
routes.post("/updateorderstatus",orderController.updateOrderStatus)


module.exports = routes