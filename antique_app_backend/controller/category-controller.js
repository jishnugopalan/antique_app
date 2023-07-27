var Category=require("../model/category")
var Subcategory=require("../model/subcategory")
const {ObjectId} =require ('mongodb');

//add category
exports.addCategory=(req,res)=>{
    console.log(req.body)
    let newCategory=Category(req.body)
                newCategory.save().then((newCategory)=>{
                
                        return res.status(200).json(newCategory)

                    
                })
}

//add subcategory
exports.addSubcategory=(req,res)=>{
    console.log(req.body)
    req.body.category=req.body.categoryid
    let subcategory=Subcategory(req.body)
                subcategory.save().then((newCategory)=>{
                
                        return res.status(200).json(newCategory)

                    
                })
}

//get all category
exports.getAllCategory=(req,res)=>{
    Category.find({}).then((category)=>{
        if(category)
        return res.status(200).json(category)
        else
        return res.status(404).json({msg:"Error"})

    })
}

//get subcategory by id
exports.getAllSubcategory=(req,res)=>{
    Subcategory.find({category:req.body.categoryid}).then((subcategory)=>{
        if(subcategory)
        return res.status(200).json(subcategory)
        else
        return res.status(404).json({msg:"Error"})

    })
}

exports.getSubCategoryById=(req,res)=>{
    console.log("inn")
    console.log(req.body)
    Subcategory.find({category:new ObjectId(req.body.categoryid)}).populate("category").exec().then((subcategory)=>{
        if(!subcategory)
        return res.status(404).json({msg:"Error in fetching subcategory"})
        else if(subcategory)
        return res.status(201).json(subcategory)

    })
}