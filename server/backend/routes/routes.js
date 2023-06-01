const express = require('express');

const router = express.Router()
const Model = require('../models/user_model');
const UserController = require("../controllers/user.controller");

module.exports = router;
router.post('/register', UserController.register);
router.post('/login', UserController.login);

// module.exports = router;
// router.post('/register', async (req, res) => {
//     const data = new Model({
//         fullName: req.body.fullName,
//         email: req.body.email,
//         password: req.body.password
//     })

//     try {
//         const dataToSave = await data.save();
//         res.status(200).json(dataToSave)
//     } catch(error) {
//         res.status(400).json({message: error.message})
//     }
// })

// router.get('/getAll', async (req, res) => {
//     try {
//         const data = await Model.find();
//         res.json(data);
//     } catch(error) {
//         res.status(500).json({message: error.message})
//     }
// })


// router.get('/getOne/:id', async (req, res) => {
//     try {
//         const data = await Model.findById(req.params.id);
//         res.json(data)
//     } catch(error) {
//         res.status(500).json({message: error.message})
//     }
// })

