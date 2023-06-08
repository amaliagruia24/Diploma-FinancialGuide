const TransactionService = require("../services/transactions.services");

exports.createTransaction = async(req, res, next) => {
    try {
        const {userId, type, day, month, year, amount, category} = req.body;
        let transaction = await TransactionService.createTransaction(userId, type, day, month, year, amount, category);
        res.status(200).json({status: true, succes: transaction});
    } catch (error) {
        throw(error);
    }
}

exports.getAllUserTransactions = async(req, res, next) => {
    try {
        let userId = req.query.userId;
        let transactions = await TransactionService.getAllUserTransactions(userId);
        if (transactions.length == 0) {
            res.status(400).json({status: false, message: "User does not have any transactions."});
        } else {
            res.status(200).json({status: true, message: transactions});
        }
    } catch (error) {
        throw(error);
    }
}