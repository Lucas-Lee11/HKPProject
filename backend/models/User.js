const mongoose = require("mongoose");

// User schema:
// - username: stores the username of the user in a String
// - password: stores the hashed password of the user
// - permissions: determines if the user has admin privileges
const userSchema = new mongoose.Schema({
  username: { type: String },
  password: { type: String },
  admin: { type: Boolean },
});

module.exports = mongoose.model("User", userSchema);
