require("dotenv").config();
const mongoose = require("mongoose");
const express=require('express')
const app=express()
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const cors = require("cors")
const port=3000

//routes

var userRoutes=require("./routes/user-routes")
var productRoutes=require("./routes/product-routes")
var orderRoutes=require("./routes/order-routes")
var shopRoute=require("./routes/shop-routes")
var complaintRoutes=require("./routes/complaint-routes")

//DB Connection
mongoose
 .connect(process.env.DATABASE, {
 useNewUrlParser: true, 
 useUnifiedTopology: true 
 })
 .then(() => {
 console.log("DB CONNECTED");
 });
// mongoose.connect('mongodb://127.0.0.1:27017/techrelics', {
//   useNewUrlParser: true,
//   useUnifiedTopology: true
// })
//   .then(() => {
//     console.log('Connected to MongoDB');
//   })
//   .catch(err => {
//     console.error('Error connecting to MongoDB:', err);
//   });

 //Middleware
app.use(bodyParser.json({limit:'10mb'}))
app.use(cookieParser());
app.use(cors());

//use routes
app.use('/api',userRoutes)
app.use('/api',productRoutes)
app.use('/api',orderRoutes)
app.use('/api',shopRoute)
app.use('/api',complaintRoutes)



//start
app.listen(port,()=>{
    console.log("App listening on port "+port)
})