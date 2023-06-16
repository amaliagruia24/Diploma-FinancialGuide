const mongoose = require('mongoose');
const UserModel = require("../models/user_model");
const {Schema} = mongoose;

const transactionSchema = new mongoose.Schema({
    userId: {
        type: Schema.Types.ObjectId, 
        ref: UserModel.modelName
    },
    type: {
        type: String, 
        required: true
    },
    day: {
        type: Number, 
        required: true
    },
    month: {
        type: String, 
        required: true,
    },
    year: {
        type: Number, 
        required: true,
    },
    amount: {
        type: Number,
        required: true,
    },
    category: {
        type: String, 
    },
    isRecurring: {
        type: Boolean,
        default: false
    },
});

module.exports = mongoose.model('Transaction', transactionSchema)
