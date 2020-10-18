const mongoose = require("mongoose");

// Item schmea:
// - name: name of the item
// - description: description of the item
// - quantity: number of the same item in a cart
const itemSchema = new mongoose.Schema({
  name: { type: String },
  description: { type: String },
  quantity: { type: Number },
  image: { type: String },
});

module.exports = mongoose.model("Item", itemSchema);
