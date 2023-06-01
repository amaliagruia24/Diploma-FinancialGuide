const mongoose = require('mongoose');
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema({
    fullName: {
        required: true, 
        type: String
    }, 
    email: {
        required: true,
        type: String, 
        unique: true
    },
    password: {
        required: true, 
        type: String
    }
});

userSchema.pre('save', async function() {
    try {
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password, salt);

        user.password = hashpass;
    } catch {
        throw error;
    }
});

userSchema.methods.comparePassword = async function(userPassword) {
    try {
        const isMatched = await bcrypt.compare(userPassword, this.password);
        return isMatched;
    } catch (error) {
        throw error;
    }
}

module.exports = mongoose.model('User', userSchema)

