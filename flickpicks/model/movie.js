const mongoose = require('mongoose');

const movieSchema = mongoose.Schema({
  dataId: {
    type: String,
    required: true,
  },
  type_data: {
    type: String,
    required: true,
  },
  poster_path: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  vote_average: {
    type: Number,
    required: true,
  },
  date: {
    type: Date,
    required: true,
  },
});

const MovieModel = mongoose.model('Movie', movieSchema);

module.exports = MovieModel;
