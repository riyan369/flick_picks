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
var reviewRoutes=require("./routes/review-routes")




// //DB Connection
// mongoose
//  .connect(process.env.DATABASE, {
//  useNewUrlParser: true, 
//  useUnifiedTopology: true 
//  })
//  .then(() => {
//  console.log("DB CONNECTED");
//  });
mongoose.connect('mongodb://127.0.0.1:27018/flickpicks', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch(err => {
    console.error('Error connecting to MongoDB:', err);
  });

 //Middleware
app.use(bodyParser.json({limit:'10mb'}))
app.use(cookieParser());
app.use(cors());


app.use('/api',userRoutes)
app.use('/api',reviewRoutes)





//start
app.listen(port,()=>{
    console.log("App listening on port "+port)
})