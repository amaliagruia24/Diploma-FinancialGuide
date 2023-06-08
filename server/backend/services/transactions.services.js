const TransactionModel = require("../models/transaction.model");

class TransactionService{
    static async createTransaction(userId, type, day, month, year, amount, category) {
        const createTransaction = new TransactionModel({userId, type, day, month, year, amount, category});
        return await createTransaction.save();
    }

    static async getAllUserTransactions(userId) {
        const transactions = TransactionModel.find({userId});
        return transactions;
    }
}

module.exports = TransactionService;