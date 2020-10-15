const mongoose = require("mongoose");

// User schema:
// - username: stores the username of the user in a String
// - password: stores the hashed password of the user
// - permissions: determines if the user has admin privileges
const userSchema = new mongoose.Schema({
  username: { type: String },
  password: { type: String },
  permission: { type: String },
});

module.exports = mongoose.model("User", userSchema);
