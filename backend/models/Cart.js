const mongoose = require("mongoose");

// Cart schema:
// - username: username of user with cart
// - name: item name
// - description: item description
// - quantity: item quantity
const cartSchema = new mongoose.Schema({
  username: { type: String },
  name: { type: String },
  description: { type: String },
  quantity: { type: Number },
});

module.exports = mongoose.model("Cart", cartSchema);
