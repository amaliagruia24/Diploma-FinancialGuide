const mongoose = require('mongoose');
const UserModel = require("../models/user_model");
const {Schema} = mongoose;

const categorySchema = new mongoose.Schema({
    categoryName: {
        type: String, 
        required: true
    }, 
    to_spend: {
        type: Number, 
        required: true
    },
    spent: {
        type: Number, 
        required: true
    }  
});

const budgetSchema = new mongoose.Schema({
    userId:{
        type: Schema.Types.ObjectId, 
        ref: UserModel.modelName
    },
    month: {
        type: String, 
        required: true
    },
    income: {
        type: Number,
        required: true
    },
    planned_expense: {
        type: Number,
        required: true
    },
    goal: {
        type: Number,
        required: true       
    },
    categories: {
        type: [categorySchema],
        default: undefined
    }
});

module.exports = mongoose.model('Budget', budgetSchema)