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

})
module.exports=mongoose.model("Auction",auctionSchema)
