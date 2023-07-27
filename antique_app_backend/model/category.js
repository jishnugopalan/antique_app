var mongoose = require("mongoose");
const {ObjectId}=require("mongodb")
var categorySchema=mongoose.Schema({ 
    category:{
        type:String,
        required:true
    },
})
module.exports=mongoose.model("Category",categorySchema)