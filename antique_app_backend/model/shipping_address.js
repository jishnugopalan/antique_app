var mongoose = require("mongoose");
const {ObjectId}=mongoose.Schema
var shippingSchema=mongoose.Schema({

    user:{
        type: ObjectId,
        required: true,
        ref:"User"
    },
    fullname:{
        type:String,
        required: true,
    },
    phone:{
        type:Number,
        required: true,
    },
    housename:{
        type:String,
        required: true,
    },
    district:{
        type:String,
        required: true,
    },
    city:{
        type:String,
        required: true,
    },
    pincode:{
        type:Number,
        required: true,
    },
   
    
})
module.exports=mongoose.model("ShippingAddress",shippingSchema);