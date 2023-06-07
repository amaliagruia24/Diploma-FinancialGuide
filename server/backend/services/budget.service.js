const BudgetModel = require("../models/budget.model");

class BudgetService {

    static async createBudget(userId, month, income, planned_expense, goal, categories) {
        const createBudget = new BudgetModel({userId, month, income, planned_expense, goal, categories});
        return await createBudget.save();
    }

    static async checkBudget(userId, month) {
        try {
            return await BudgetModel.findOne({userId: userId, month: month});
        } catch (error) {
            throw error;
        }
    }

    static async getUserBudgets(userId) {
        const budget = await BudgetModel.find({userId})
        return budget; 
    }

    static async getUserBudgetByMonth(userId, month) {
        const monthBudget = await BudgetModel.find({userId: userId, month: month});
        return monthBudget;
    }
}

module.exports = BudgetService;