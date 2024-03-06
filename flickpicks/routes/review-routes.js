var express = require('express');
var routes = express.Router();
var reviewController=require("../controller/review-controller")



routes.post('/savereview',reviewController.addReview);
routes.post('/getreview',reviewController.getReview);


module.exports = routes;
