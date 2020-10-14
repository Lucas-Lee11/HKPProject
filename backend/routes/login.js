import { Router } from "express";
const router = Router();

import { User } from "../models/User";
//const User = require("../models/User");

router.post("/login", async (req, res, next) => {
  const user = await User.findOne({ username: req.body.username });
  if (!user)
    return res.status(400).send({ message: "Username or password is wrong." });

  if (req.body.password !== user.password)
    return res.status(400).send({ message: "Username or password is wrong." });

  try {
    res.send({ message: "Logged in" });
  } catch (err) {
    res.status(400).send({ message: err });
  }
});

module.exports = router;
