const UserService = require("../services/user.service");

exports.register = async(req, res, next) => {
    try {
        const {fullName, email, password} = req.body;
        const user = await UserService.checkUser(email);
        
        if(user != null) {
            res.status(400).json({status: false, message: "Email already exists!"});
        } else {
            const succes = await UserService.register(fullName, email, password);
            res.json({status:true, succes: "User registered succesfuly"})
        }
    } catch(error){
        throw error;
    }
}

exports.login = async(req, res, next) => {
    try {
        const {email, password} = req.body;
        const user = await UserService.checkUser(email);

        if(!user) {
            // res.status(400).json({status: false, message: "user does not exist"});
            throw new Error('User does not exist');
        }

        const isMatched = await user.comparePassword(password);
        if(isMatched === false) {
            throw new Error('Incorrect password');
        }

        let tokenData = {_id: user._id, email:user.email, fullName: user.fullName};
        //console.log(user._id.toString());
        const token = await UserService.generateToken(tokenData, "secret key", '1h');

        res.status(200).json({status: true, token: token});

    } catch(error){
        throw error;
    }
}

