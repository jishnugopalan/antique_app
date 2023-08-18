var express = require('express')
routes = express.Router()
const auctionController=require("../controller/auction-controller")
routes.post("/addAuctionItem",auctionController.addAuctionItem)
routes.post("/getAllAuction",auctionController.getAllAuction)

routes.post("/getAuctionByShopid",auctionController.getAuctionByShopid)
routes.post("/getAuctionById",auctionController.getAuctionById)
routes.post("/deleteAuctionById",auctionController.deleteAuctionById)
routes.post("/updateAuctionStatus",auctionController.updateAuctionStatus)
routes.post("/updateBid",auctionController.updateBid)

//routes.post("/getHighestBidByAuctionId",auctionController.getHighestBidByAuctionId)

module.exports = routes
