const BudgetService = require("../services/budget.service");

exports.createBudget = async(req, res) => {
    try {
      const {userId, month, income, planned_expense, goal, categories} = req.body;  
      const foundBudget = await BudgetService.checkBudget(userId, month);
      if(foundBudget != null) {
        res.status(400).json({status: false, message: "User already has a budget for this month!"});
      } else {
        let budget = await BudgetService.createBudget(userId, month, income, planned_expense, goal, categories);
        res.status(200).json({status: true, success: budget});
      }
    } catch (error) {
        throw(error);
    }
}

exports.getUserBudgets = async(req, res, next) => {
    try {
        const {userId} = req.body;
        let budget = await BudgetService.getUserBudgets(userId);

        res.json({status: true, success: budget});
    } catch (error) {
        
    }
}

exports.getUserBudgetByMonth = async(req, res, next) => {
    try {
        // const {userId, month} = req.body;
        var userId = req.query.userId;
        var month = req.query.month;
        let monthBudget = await BudgetService.getUserBudgetByMonth(userId, month);

        if(monthBudget == null) {
            res.status(404).json({status:false, message: "User did not set a budget for the month entered"});
        } else {
            res.status(200).json({status:true, message: monthBudget});
        }
    
    } catch (error) {
        throw(error);
    }
}

exports.updateSpentOnCategory = async(req, res, next) => {
    try {
        var userId = req.query.userId;
        var month = req.query.month;
        var categoryName = req.query.categoryName;
        var amount = req.query.amount;
        let updatedBudget = await BudgetService.updateSpentOnCategory(userId, month, categoryName, amount);
        res.status(200).json({status:true, message: updatedBudget});
    } catch (error) {
        throw(error);
    }
}

exports.updateBudgetIncome = async(req, res, next) => {
    try {
        var userId = req.query.userId;
        var month = req.query.month;
        var amount = req.query.amount;
        let updatedBudget = await BudgetService.updateBudgetIncome(userId, month, amount);
        res.status(200).json({status: true, message: updatedBudget});
    } catch (error) {
        throw(error);
    }
}

