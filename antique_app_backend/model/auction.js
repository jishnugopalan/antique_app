var mongoose = require("mongoose");
const {ObjectId}=require("mongodb")
const auctionSchema=new mongoose.Schema({
    shop:{
        type:ObjectId,
        required:true,
        ref:'Shop'
    },
    productname:{
        type:String,
        required:true
    },
    image:{
        type:String,
        required:true,
    },
    description:{
        type:String,
        required:true,
    },
    availability:{
        type:String,
        required:true,
        default:"Available"
    },
    price:{
        type:Number,
        required:true
    },
    bids: [
        {
        bidder: {
          type: ObjectId,
          ref: 'User', // Assuming you have a User model for bidders
          required: true,
        },
        bidAmount: {
          type: Number,
          required: true,
        },
        bidTime: {
          type: String,
          default:Date.now()
        },
      }
    ],

})
module.exports=mongoose.model("Auction",auctionSchema)
