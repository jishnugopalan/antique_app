
const Order=require("../model/order")
const mongoose=require("mongoose")
const Payment=require("../model/payment")
const {ObjectId}=require("mongodb")
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
exports.getOrderByShopId=(req,res)=>{
    const vendorId = req.body.shopid 

Order.aggregate([
  {
    $lookup: {
      from: 'products',
      localField: 'products.product',
      foreignField: '_id',
      as: 'products',
    },
  },
  {
    $match: {
      'products.shop': mongoose.Types.ObjectId(vendorId),
    },
  },
  {
    $lookup: {
      from: 'users',
      localField: 'user',
      foreignField: '_id',
      as: 'user',
    },
  },
  {
    $unwind: '$user',
  },
])
  .exec().then((orders) => {
    if (orders) {
        return res.status(201).json(order)
        
      } else {
        return res.status(404).json({msg:"Error in fetching order"})
      }
  });

}

//get order by userid
exports.getOrderByUserid=(req,res)=>{
const userId = req.body.userid; 
Order.find({ user: userId })
  .populate('user')
  .populate('products.product')
  .exec().then((orders) => {
    if (orders) {
        return res.status(201).json(order)
        
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
    // req.body.order=new ObjectId(req.body.order)
    // let newPayment=Payment(req.body)
    // Product.updateOne({_id:new ObjectId(req.body.product)},{
    //     $inc: { stock: -(parseInt(req.body.qty))} 
    // }).then((updated)=>{
    //     if(!updated)
    //     return res.status(404).json({msg:err})
    //     else if(updated){
    //         newPayment.save().then((payment)=>{
    //             if(!payment)
    //             return res.status(404).json({msg:err})
    //             if(payment){
    //                // return res.status(201).json(payment)
    //                 Order.updateOne({_id:new ObjectId(req.body.order)},{
    //                     $set:{
    //                         order_status:"Payment Completed"
    //                     }
    //                 }).exec().then((upd)=>{
    //                     if(!upd)
    //                     return res.status(404).json({msg:"Error in payment"})
    //                     else if(upd)
    //                     return res.status(201).json({msg:"Payment completed"})
    //                 })
    //             }
                
    //         })

    //     }
       
    // })
    
}
