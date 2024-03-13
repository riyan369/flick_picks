var Favorite=require("../model/favorite")
var MovieM = require("../model/movie")
var jwt=require("jsonwebtoken");
const expressjwt=require("express-jwt");
const {ObjectId}=require("mongodb");


exports.addFavorite = async (req, res) => {
  console.log(req.body);
  const { fav, movie } = req.body;
  const parsedFav = JSON.parse(fav);
  const parsedMovie = JSON.parse(movie);

  const { typeId, userId, type } = parsedFav;
  const { dataId, type_data, poster_path, name, vote_average, date } = parsedMovie;

  try {
    // Check if the user with userId already exists in favorites
    const existingFavorite = await Favorite.findOne({ userId: userId });

    if (!existingFavorite) {
      // If user doesn't exist, create a new favorite record
      const newFavorite = new Favorite({
        typeId: typeId,
        userId: userId,
        type: type,
      });
      await newFavorite.save();
      console.log('Favorite saved successfully:', newFavorite);

      // Check if the movie with dataId already exists in the Movie database
      const existingMovie = await MovieM.findOne({ dataId: dataId });
      console.log("working", dataId);
      if (!existingMovie) {
        console.log("working1111", dataId);

        // If movie doesn't exist, create a new movie record
        const newMovie = new MovieM({
          dataId: dataId,
          type_data: type_data, // Ensure that type_data is included
          poster_path: poster_path,
          name: name,
          vote_average: vote_average,
          date: date,
        });
        
        
        await newMovie.save();
        console.log('Movie saved successfully:', newMovie);
      }

      return res.status(201).json(newFavorite);
    }

    // If user exists, check if typeId already exists in the array
    if (existingFavorite.typeId.includes(typeId)) {
      return res.status(404).json({ error: 'Type ID already exists in the array' });
    }

    // Add typeId to the array
    existingFavorite.typeId.push(typeId);

    // Save the updated favorite record
    await existingFavorite.save();
    
    
    console.log('Favorite updated successfully:', existingFavorite);
    const existingMovie = await MovieM.findOne({ dataId: dataId });

    if (!existingMovie) {
      console.log("working1111", dataId);

      // If movie doesn't exist, create a new movie record
      const newMovie = new MovieM({
        dataId: dataId,
        type_data: type_data, // Ensure that type_data is included
        poster_path: poster_path,
        name: name,
        vote_average: vote_average,
        date: date,
      });
      
      
      await newMovie.save();
      console.log('Movie saved successfully:', newMovie);
    }
    
    

    return res.status(201).json(existingFavorite);
  } catch (error) {
    console.error('Error saving Favorite:', error);
    return res.status(500).json({ msg: 'Internal Server Error' });
  }
};




exports.getFavorite = async (req, res) => {
  console.log(req.body);
  try {
    const { userId } = req.body;
    console.log(userId);

    // Find records in the Favorite model for the specific user
    const favorites = await Favorite.find({ userId: userId });

    if (!favorites || favorites.length === 0) {
      console.log("errrrrrrr1");
      return res.status(404).json({ msg: 'Favorites not found for the user' });
    }

    // Extract all typeId values from the favorites
    const typeIds = favorites.flatMap((favorite) => favorite.typeId);

    // Find all movies with dataId in the list of typeIds
    const movies = await MovieM.find({ dataId: { $in: typeIds } });

    // Return the results
    console.log(movies);
    return res.status(200).json({ favorites, movies });
  } catch (error) {
    console.error('Error getting favorites:', error);
    return res.status(500).json({ msg: 'Internal Server Error' });
  }
};

  