// Import libraries and databases
// - Express is the monolith server backend
// - Item database
const router = require("express").Router();
const jwt = require("jsonwebtoken");
const Cart = require("../models/Cart");

router.get("/cart", async (req, res, next) => {
  const user = jwt.verify(req.body.token, process.env.TOKEN_SECRET);
  try {
    const cart = await Cart.find({ username: user.username });
    res.send(cart);
  } catch (err) {
    res.status(400).send({ message: err });
  }
});

router.post("/cart", async (req, res, next) => {
  const user = jwt.verify(req.body.token, process.env.TOKEN_SECRET);
  await Cart.deleteMany({ username: user.username });

  const cart = req.body.cart;

  for (let i = 0; i < cart.length; ++i) {
    const item = cart[i];
    console.log(req.body.token);
    const cartItem = new Cart({
      username: user.username,
      name: item["name"],
      description: item["description"],
      quantity: Number(item["quantity"]),
      image: item["image"],
    });

    try {
      await cartItem.save();
      res.send({ message: "Cart saved." });
    } catch (err) {
      res.status(400).send({ message: err });
    }
  }
});

module.exports = router;
