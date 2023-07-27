var mongoose = require("mongoose");
const {ObjectId}=require("mongodb")
var shopSchema=mongoose.Schema({
    user:{
        type: ObjectId,
        required: true,
        ref:"User"
    },
    shopname:{
        type:String,
        required:true
    },
    shopcity:{
        type:String,
        required:true
    },
    shopdistrict:{
        type:String,
        required:true
    }, 
    shoppincode:{
        type:String,
        required:true
    }, 
    shopphone:{
        type:Number,
        required:true
    }, 
    shopemail:{
        type:String,
        required:true
    }, 
    shoplicense:{
        type:String,
        required:true
    },
    admin_status:{
        type:String,
        default:"Pending"
    }
})
module.exports=mongoose.model("Shop",shopSchema);