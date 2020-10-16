// Import libraries and databases
// - Express is the monolith server backend
// - Bcryptjs is for password hashing
// - JWT is for JSON tokens for auth
// - User database
const router = require("express").Router();
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

router.post("/users/register", async (req, res, next) => {
  // Check if username in request body is empty and/or null
  if (req.body.username == null)
    return res.status(400).send({ message: "Username field cannot be empty." });

  // Check if password in request body is empty and/or null
  if (req.body.password == null)
    return res.status(400).send({ message: "Password field cannot be empty." });

  // Check if username already exists within the User database
  const username = await User.findOne({ user: req.body.username });
  if (username)
    return res.status(409).send({ message: "User already exists." });

  // Hash passwords with a salt using bcrypt
  const salt = await bcrypt.genSalt();
  const hashedPassword = await bcrypt.hash(req.body.password, salt);

  // Create new user using the User schema
  const user = new User({
    username: req.body.username,
    password: hashedPassword,
    permission: req.body.permission,
  });

  try {
    await user.save();
    // Create and sign a token with the database user id and
    // username. Expires in one day after creation
    const payload = { _id: user._id, username: user.username };
    const token = jwt.sign(payload, process.env.TOKEN_SECRET, {
      expiresIn: "1d",
    });

    // Send token to front-end
    res.send({ token: token });
  } catch (err) {
    res.status(400).send({ message: err });
  }
});

module.exports = router;
