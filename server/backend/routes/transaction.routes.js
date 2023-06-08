const express = require('express');

const router = express.Router()
const TransactionController = require("../controllers/transaction.controller");

router.post('/addTransaction', TransactionController.createTransaction);
router.get('/getAllUserTransactions', TransactionController.getAllUserTransactions);
module.exports = router;