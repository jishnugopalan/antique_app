var mongoose = require("mongoose");
const {ObjectId}=require("mongodb")
const orderSchema = new mongoose.Schema({
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    products: [
      {
        product: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'Product',
        },
        quantity: {
          type: Number,
          required: true,
          default: 1,
        },
      },
    ],
    total: {
      type: Number,
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    orderstatus:{
      type:String,
      default:"Order Pending"
    },
    shippingid:{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'ShippingAddress',
    }
  });
  module.exports=mongoose.model("Order",orderSchema)