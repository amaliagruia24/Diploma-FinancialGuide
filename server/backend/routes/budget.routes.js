const express = require('express');

const router = express.Router()
const BudgetController = require("../controllers/budget.controller");

router.post('/addBudget', BudgetController.createBudget);
router.get('/getUserBudgets', BudgetController.getUserBudgets);
router.get('/getUserBudgetByMonth', BudgetController.getUserBudgetByMonth);
router.put('/updateSpentOnCategory', BudgetController.updateSpentOnCategory);
module.exports = router;