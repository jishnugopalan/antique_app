
const Order=require("../model/order")
const mongoose=require("mongoose")
const Payment=require("../model/payment")
const {ObjectId}=require("mongodb")
const payment = require("../model/payment")
const Cart=require("../model/cart")
const Product=require("../model/product")
//create order
exports.createOrder=(req,res)=>{
    let newOrder=Order(req.body)
    newOrder.save().then((savedOrder)=>{
        if (savedOrder) {
            return res.status(201).json(savedOrder)
        
        } else {
          return res.status(404).json({msg:"Error in crreating order"})
        }
      });
}

//get order by id
exports.getOrderById=(req,res)=>{
    Order.findById(req.body.orderid)
    .populate('user')
    .populate('products.product')
    .exec().then((order) => {
      if (order) {
        return res.status(201).json(order)
        
      } else {
        return res.status(404).json({msg:"Error in fetching order"})
      }
    });
}

//get order by shop id
exports.getOrderByShopId=async (req,res)=>{
    const shopId = req.body.shopid 
    try {
      const orders = await Order.find({
        "products.product": { $exists: true },
      })
        .populate({
          path: "products.product",
          match: { shop: shopId },
        })
        .exec();
  
      // Filter the orders that have at least one product with the given shopId
     
      const ordersWithShopProducts = orders.filter((order) => {
        return order.products.some((product) => {
          return product.product !== null;
        });
      });
      return res.status(201).json(ordersWithShopProducts)
    } catch (err) {
      console.error("Error finding orders by shop ID:", err);
      throw err;
    }

}

//get order by userid
exports.getOrderByUserid=(req,res)=>{
const userId = req.body.userid; 
Order.find({ user: userId })
  .populate('user')
  .populate('products.product')
  .exec().then((orders) => {
    if (orders) {
        return res.status(201).json(orders)
        
      } else {
        return res.status(404).json({msg:"Error in fetching order"})
      }
  });

}

exports.cancelOrder=(req,res)=>{
    Order.updateOne({_id:ObjectId(req.body.orderid)},{
        $set:{
            order_status:"Order Cancelled"
        }
    }).then((delorder)=>{
        if(!delorder)
        return res.status(404).json({msg:"Error in cancel order"})
        if(delorder)
        return res.status(201).json({msg:"Order cancelled successfully"})

    })
}

//productid,orderid,stock
exports.startPayment=(req,res)=>{
    console.log(req.body)
    let newPayament=Payment(req.body)
    newPayament.save().then((payment)=>{
      if(payment){
        return res.status(201).json(payment)
      }
      else{
        return res.status(404).json({msg:"Error in inserting payment"})
      }
    })
    
}
exports.decreaseProductsStock=(req,res)=>{
  Product.updateOne({_id:req.body.product},{
    $inc: { stock: -(parseInt(req.body.qty))}}).then((upd)=>{
      if(upd){
        return res.status(201).json(upd)
      }
      else{
        return res.status(404).json({msg:"error in updating data"})
      }
    })

}

exports.deleteAllItemFromCart=(req,res)=>{
  Cart.deleteMany({user:req.body.userid}).then((cart)=>{
    if(cart){
      return res.status(201).json(cart)
    }
    else{
      return res.status(404).json({msg:"Error in deleteing cart"})
    }
  })
}

exports.updateOrderStatus=(req,res)=>{
  Order.updateOne({_id:req.body.orderid},{
    $set:{
      orderstatus:req.body.status
    }
  }).then((upd)=>{
    if(upd){
      return res.status(201).json(upd)
    }
    else{
      return res.status(404).json({msg:"error in updating data"})
    }
  })
}