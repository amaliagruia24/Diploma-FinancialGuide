const TransactionModel = require("../models/transaction.model");
const BudgetService = require("../services/budget.service");
class TransactionService{
    static async createTransaction(userId, type, day, month, year, amount, category, isRecurring) {
        const createTransaction = new TransactionModel({userId, type, day, month, year, amount, category, isRecurring});
        if (type === "income") {
            BudgetService.updateBudgetIncome(userId, month, amount);
        } else if(type === "expense") {
            BudgetService.updateSpentOnCategory(userId, month, category, amount);
        }
        return await createTransaction.save();
    }

    static async getAllUserTransactions(userId) {
        const transactions = TransactionModel.find({userId});
        return transactions;
    }

    static async getRecurringTransactions(userId, month) {
        const transactions = TransactionModel.find({userId: userId, month: month, isRecurring: true})
        return transactions;
    }
}

module.exports = TransactionService;