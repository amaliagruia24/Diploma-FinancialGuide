const express = require('express');

const router = express.Router()
const Model = require('../models/user_model');
const UserController = require("../controllers/user.controller");

module.exports = router;
router.post('/register', UserController.register);
router.post('/login', UserController.login);
router.put('/updatePassword', UserController.update);

