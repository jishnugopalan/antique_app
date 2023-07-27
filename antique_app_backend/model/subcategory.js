const mongoose=require ("mongoose")
const {ObjectId} =require ('mongodb');
var subcategorySchema=new mongoose.Schema({
    
    category:{
        type:ObjectId,
        ref:"Category",
        require:true

    },
    subcategory:{
        type:String,
        require:true
    }

})
module.exports=mongoose.model("Subcategory",subcategorySchema)