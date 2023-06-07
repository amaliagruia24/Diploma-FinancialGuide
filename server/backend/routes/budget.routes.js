const express = require('express');

const router = express.Router()
const BudgetController = require("../controllers/budget.controller");

router.post('/addBudget', BudgetController.createBudget);
router.get('/getUserBudgets', BudgetController.getUserBudgets);
router.get('/getUserBudgetByMonth', BudgetController.getUserBudgetByMonth);

module.exports = router;