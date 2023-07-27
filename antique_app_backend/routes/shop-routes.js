var express = require('express')
routes = express.Router()
const shopController=require("../controller/shop-controller")
routes.post("/getall-shops",shopController.getallShops)
routes.post("/getnot-approved-shops",shopController.getNotApprovedShops)
routes.post("/approve-shops",shopController.approveShop)
routes.post("/reject-shops",shopController.rejectShop)
routes.post("/getshop-by-id",shopController.viewShopById)
routes.post("/getshop-by-userid",shopController.getShopByUserid)

module.exports = routes