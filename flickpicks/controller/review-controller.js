var User=require("../model/review")
var jwt=require("jsonwebtoken");
const expressjwt=require("express-jwt");
const {ObjectId}=require("mongodb");


exports.addReview=(req,res)=>{
    console.log(req.body)
    let newReview=User(req.body)
    newReview.save()
  .then(result => {
    console.log('Review saved successfully:', result);
    return res.status(201).json(result)
  })
  .catch(error => {
    console.error('Error saving review:', error);
    return res.status(404).json({msg:"Error saving review"})
  });
   }


exports.getReview=(req,res)=>{
    console.log(req.body)
    return res.status(201).json(req.body)


}
   