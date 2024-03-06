var User=require("../model/user")
var jwt=require("jsonwebtoken");
const expressjwt=require("express-jwt");
const {ObjectId}=require("mongodb");


exports.addUser=(req,res)=>{
    console.log(req.body)
    User.findOne({email:req.body.email}).then((user)=>{
       if(user){
         return res.status(404).json({msg:"User already exist"})
       }
       else{
           //customer registration
           if(req.body.usertype=="customer"){
               let newUser=User(req.body)
               newUser.save().then((customer)=>{
                   if(customer){
                       return res.status(201).json(customer)
                   }
                   else{
                       return res.status(404).json({msg:"Error in adding customer"})
                   }
               })
             }  }
          
    })
   }



   exports.login=(req,res)=>{
    console.log(req.body)
    User.findOne({email:req.body.email,password:req.body.password},{email:1,usertype:1,name:1}).then((user)=>{
        if(user){
            const token=jwt.sign({_id:user._id},"test_value");
            res.cookie("token",token,{expire:new Date()+9999});
            return res.status(200).json({token,user})
        }
        else{
            return res.status(404).json({msg:"Incorect email id or password"})
        }
    })
}

exports.findUser=(req,res)=>{
    console.log(req.body)
    User.findOne({_id:new ObjectId(req.body.userid)}).then((user)=>{
        if(!user){
            return res.status(404).json({error:"User not found"})
        }
        else if(user){
            return res.status(201).json(user)
        }
        
    })
}

exports.updatePhoneNumber=(req,res)=>{
    User.updateOne({_id:req.body.userid},{
        $set:{
            phone:req.body.phone
        }
    }).then((user)=>{
        if(!user){
            return res.status(404).json({error:"User not found"})
        }
        else if(user){
            return res.status(201).json(user)
        }
    })
}
exports.updateEmail=(req,res)=>{
    User.updateOne({_id:req.body.userid},{
        $set:{
            email:req.body.email
        }
    }).then((user)=>{
        if(!user){
            return res.status(404).json({error:"User not found"})
        }
        else if(user){
            return res.status(201).json(user)
        }
    })
}
exports.updatePassword=(req,res)=>{
    User.updateOne({_id:req.body.userid},{
        $set:{
            password:req.body.password
        }
    }).then((user)=>{
        if(!user){
            return res.status(404).json({error:"User not found"})
        }
        else if(user){
            return res.status(201).json(user)
        }
    })
}
exports.findUserByEmail=(req,res)=>{
    User.findOne({email:req.body.email}).then((user)=>{
        if(!user){
            return res.status(404).json({error:"User not found"})
        }
        else if(user){
            return res.status(201).json(user)
        }
        
    })
}