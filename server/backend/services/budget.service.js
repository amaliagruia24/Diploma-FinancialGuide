const BudgetModel = require("../models/budget.model");
const UserModel = require("../models/user_model");
const mongoose = require("mongoose");
const { Schema } = mongoose;
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
        const monthBudget = await BudgetModel.findOne({userId: userId, month: month}).populate("categories");
        return monthBudget;
    }

    static async updateSpentOnCategory(userId, month, categoryName, amount) {
        const foundBudget = await BudgetService.getUserBudgetByMonth(userId, month);
        for(let i = 0; i < foundBudget.categories.length; ++i) {
            if (foundBudget.categories[i].categoryName === categoryName) {
                foundBudget.categories[i].spent = foundBudget.categories[i].spent + amount;
            }
        }
        return foundBudget.save();
    }

    static async updateBudgetIncome(userId, month, amount) {
        const foundBudget = await BudgetService.getUserBudgetByMonth(userId, month);
        foundBudget.income = foundBudget.income + amount;
        return foundBudget.save();
    } 
}

module.exports = BudgetService;