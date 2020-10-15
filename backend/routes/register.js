const router = require("express").Router();
const User = require("../models/User");

router.post("/users/register", async (req, res, next) => {
  if (req.body.username == null)
    return res.status(400).send({ message: "Username field cannot be empty." });

  if (req.body.password == null)
    return res.status(400).send({ message: "Password field cannot be empty." });

  const username = await User.findOne({ user: req.body.username });
  if (username)
    return res.status(409).send({ message: "User already exists." });

  const user = new User({
    username: req.body.username,
    password: req.body.password,
    permissions: "customer",
  });

  try {
    const savedUser = await user.save();
    res.send({ user: savedUser });
  } catch (err) {
    res.status(400).send({ message: err });
  }
});

module.exports = router;
