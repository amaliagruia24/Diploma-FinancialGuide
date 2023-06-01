const Model = require('../models/user_model');
const jwt = require("jsonwebtoken");
class UserService {
    static async register(fullName, email, password) {
        try {
            const createUser = new Model({fullName, email, password});
            return await createUser.save();
        }catch(error) {
            throw error;
        }
    }

    static async checkUser(email) {
        try {
            return await Model.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData, secretKey, jwt_expire) {
        return await jwt.sign(tokenData, secretKey, {expiresIn: jwt_expire})
    }
}

module.exports = UserService;