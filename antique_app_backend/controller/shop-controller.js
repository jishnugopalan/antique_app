const Shop=require("../model/shop")
exports.getallShops=(req,res)=>{
    Shop.find().populate("user").then((shop)=>{
        if(shop){
            return res.status(200).json(shop)
        }
        else{
            return res.status(404).json({msg:"Error in fetching shop details"})
        }
    })
}

exports.getNotApprovedShops=(req,res)=>{
    Shop.find({admin_status:"Pending"}).populate("user").then((shop)=>{
        if(shop){
            return res.status(200).json(shop)
        }
        else{
            return res.status(404).json({msg:"Error in fetching shop details"})
        }
    })
}

exports.approveShop=(req,res)=>{
    Shop.updateOne({_id:req.body.shopid},{
        $set:{
            admin_status:"Active"
        }
    }).then((shop)=>{
        if(shop){
            return res.status(200).json(shop)
        }
        else{
            return res.status(404).json({msg:"Error in fetching shop details"})
        }
    })
}

exports.rejectShop=(req,res)=>{
    Shop.updateOne({_id:req.body.shopid},{
        $set:{
            admin_status:"Rejected"
        }
    }).then((shop)=>{
        if(shop){
            return res.status(200).json(shop)
        }
        else{
            return res.status(404).json({msg:"Error in fetching shop details"})
        }
    })
}

exports.viewShopById=(req,res)=>{
    Shop.findOne({_id:req.body.shopid}).populate("user").then((shop)=>{
        if(shop){
            return res.status(200).json(shop)
        }
        else{
            return res.status(404).json({msg:"Error in fetching shop details"})
        }
    })
}

exports.getShopByUserid=(req,res)=>{
    Shop.findOne({user:req.body.userid}).then((shop)=>{
        if(!shop){
            return res.status(404).json({error:err})
            }
            else{
                return res.status(201).json(shop)
            }
    })
}