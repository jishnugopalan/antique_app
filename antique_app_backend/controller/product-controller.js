var Product=require("../model/product")
var Shop=require("../model/shop")
const {ObjectId} =require ('mongodb');
var Cart=require("../model/cart")
const Shipping=require("../model/shipping_address")

//add product
exports.addProduct=(req,res)=>{
    console.log(req.body)
    
    let Newproduct=Product(req.body)
    Newproduct.save().then((newuser)=>{
        if(newuser){
            return res.status(201).json(newuser)

        }
        else{
        
            return res.status(404).json({error:"Error in inserting data"})

        }
    })
}

//get product by shop id
exports.getProductByShopId=(req,res)=>{
    Product.find({shop:req.body.shopid}).populate("category").populate("subcategory").exec().then((product)=>{
        if(!product)
        return res.status(404).json({msg:"Error in fetching products"})
        else if(product)
        return res.status(201).json(product)
    })
}

//get product by category
exports.getProductByCategory=(req,res)=>{
    Product.find({category:new ObjectId(req.body.categoryid)}).populate("category").populate("subcategory").exec().then((product)=>{
        if(!product)
        return res.status(404).json({msg:"Error in fetching products"})
        else if(product)
        return res.status(201).json(product)
    })
}

//get product by subcategory
exports.getProductBySubCategory=(req,res)=>{
    Product.find({subcategory:new ObjectId(req.body.subcategoryid)}).populate("category").populate("subcategory").exec().then((product)=>{
        if(!product)
        return res.status(404).json({msg:"Error in fetching products"})
        else if(product)
        return res.status(201).json(product)
    })
}

//get product by productid
exports.getProductById=(req,res)=>{
    Product.findOne({_id:req.body.productid}).populate("category").populate("subcategory").populate("shop").then((product)=>{
      if(product)
        return res.status(201).json(product)
      else
        return res.status(404).json({msg:"Error in fetching products"})


    })
}

//delete product
exports.deleteProductById=(req,res)=>{
    Product.deleteOne({_id:ObjectId(req.body.productid)}).then((delproduct)=>{
        if(!delproduct)
        return res.status(404).json({msg:"Error in getting cart data"})
        else if(delproduct)
        return res.status(201).json({msg:"Product removed"})
    })

}

//get all product
exports.getAllProducts=(req,res)=>{
    Product.find().populate("category").populate("subcategory").populate("shop").then((products)=>{
     if(products){
        return res.status(201).json(products)

     }
     else{
        return res.status(404).json({msg:"Error in getting products"})

     }
    })
}

//update price
exports.updateProductPrice=(req,res)=>{
    Product.updateOne({_id:new ObjectId(req.body.productid)},{
        $set:{
            price:req.body.price
        }
    }).then((updated)=>{
        if(!updated)
        return res.status(404).json({msg:"Error in updating data"})
        else if(updated)
        return res.status(201).json({msg:"Product price updated"})
    })
}


//update discount
exports.updateProductDiscount=(req,res)=>{
    Product.updateOne({_id:new ObjectId(req.body.productid)},{
        $set:{
            discount_percentage:req.body.discount_percentage
        }
    }).then((updated)=>{
        if(!updated)
        return res.status(404).json({msg:"Error in updating data"})
        else if(updated)
        return res.status(201).json({msg:"Product price updated"})
    })
}

//update availability
exports.updateProductAvailability=(req,res)=>{
    console.log(req.body)
    Product.updateOne({_id:new ObjectId(req.body.productid)},{
        $set:{
            availability:req.body.availability
        }
    }).then((updated)=>{
        if(!updated)
        return res.status(404).json({msg:"Error in updating data"})
        else if(updated)
        return res.status(201).json({msg:"Product availabilty updated"})
    })
}

//update stock
exports.updateProductStock=(req,res)=>{
    Product.updateOne({_id:new ObjectId(req.body.productid)},{
        $set:{
            stock:req.body.stock
        }
    }).then((updated)=>{
        if(!updated)
        return res.status(404).json({msg:"Error in updating data"})
        else if(updated)
        return res.status(201).json({msg:"Product price updated"})
    })
}


//cart
exports.addToCart=(req,res)=>{
    let newCart=Cart(req.body)
    newCart.save().then((cart)=>{
        if(!cart)
        return res.status(404).json({msg:"Error in inserting data"})
        else if(cart)
        return res.status(201).json(cart)
    })    
}

//find cart by userid
exports.getCartByUser=(req,res)=>{
    // let newCart=Cart(req.body)
    // newCart.save().then((cart)=>{
    //     if(!cart)
    //     return res.status(404).json({msg:"Error in inserting data"})
    //     else if(cart)
    //     return res.status(201).json(cart)
    // })  
    Cart.find({ user: req.body.userid })
    .populate('user')
    .populate('products.product')
    .then((cart) => {
        if (!cart) {
        console.error('Error fetching cart:', error);
        return res.status(404).json({msg:"Error in getting data"})
        } else {
        console.log('Cart for the user:', cart);
        return res.status(201).json(cart)
        }
    });
} 


//delete cart item
exports.deleteCartProduct=(req,res)=>{
Cart.deleteOne({_id:req.body.cartid}).then((cart)=>{
    if(cart){
        return res.status(201).json(cart)
    }else{
        return res.status(404).json({msg:"Error in updating data"})
    }
})
}

exports.addShippingAddress=(req,res)=>{
   let newAddress=Shipping(req.body)
   newAddress.save().then((address)=>{
    if(address){
        return res.status(201).json(address)
    }
    else{
        return res.status(404).json({msg:"error"})
    }
   })
}