var express = require('express');
var routes = express.Router();
var reviewController=require("../controller/favorite-controller")



routes.post('/savefav',reviewController.addFavorite);
routes.post('/getfav',reviewController.getFavorite);


module.exports = routes;
