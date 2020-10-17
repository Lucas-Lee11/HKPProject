// Import libraries and databases
// - Express is the monolith server backend
// - Bcryptjs is for password hashing
// - JWT is for JSON tokens for auth
// - User database
const router = require("express").Router();
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

router.post("/users/login", async (req, res, next) => {
  // Check if a username was sent in request and validate it otherwise 400 error
  const user = await User.findOne({ username: req.body.username });
  if (!user)
    return res.status(400).send({ message: "Username or password is wrong." });

  // Validate password in request body against hashed password in database
  const validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword)
    return res.status(400).send({ message: "Username or password is wrong." });

  // Create and sign a token with the database user id and
  // username. Expires in one day after creation
  const payload = { _id: user._id, username: user.username };
  const token = jwt.sign(payload, process.env.TOKEN_SECRET, {
    expiresIn: "1d",
  });

  try {
    // Send JWT token to front-end
    res.send({ token: token });
  } catch (err) {
    res.status(400).send({ message: err });
  }
});

module.exports = router;
