var Review=require("../model/review")
var jwt=require("jsonwebtoken");
const expressjwt=require("express-jwt");
const {ObjectId}=require("mongodb");


exports.addReview=(req,res)=>{
    console.log(req.body)
    let newReview=Review(req.body)
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



   exports.getReview = async (req, res) => {
    const { movieid } = req.body;
    console.log(req.body);
  
    try {
      // Retrieve reviews for the specified movie ID
      const reviews = await Review.find({ movieId: movieid });
  
      // Check if reviews exist for the given movie ID
      if (!reviews || reviews.length === 0) {
        return res.status(404).json({ error: 'No reviews found for the specified movie ID' });
      }
  
      // Calculate the average rating
      const totalRatings = reviews.reduce((sum, review) => sum + parseFloat(review.rating), 0);
      const averageRating = totalRatings / reviews.length;
  
      // Extract "review" and "username" keys from each review
      const reviewsData = reviews.map(review => ({
        review: review.review,
        username: review.username,
        rating: review.rating,
      }));
      console.log(reviewsData);
      // Return the "review" and "username" keys along with average rating in the response
      return res.status(200).json({ reviews: reviewsData, averageRating });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  