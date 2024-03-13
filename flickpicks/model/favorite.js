const mongoose = require('mongoose');

const favoriteSchema = mongoose.Schema({
  type: {
    type: String,
    required: true,
  },
  typeId: {
    type: [String],
    required: true,
  },
  userId: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Favorite', favoriteSchema);
