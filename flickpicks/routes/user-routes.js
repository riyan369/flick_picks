var express = require('express');
var routes = express.Router();
var userController=require("../controller/user-controller")


routes.post('/login',userController.login)

routes.post('/register',userController.addUser)
routes.post('/getuser',userController.findUser)

routes.post('/updatePhoneNumber',userController.updatePhoneNumber)
routes.post('/updateEmail',userController.updateEmail)
routes.post('/updatePassword',userController.updatePassword)
routes.post('/findUserByEmail',userController.findUserByEmail)

module.exports = routes;
