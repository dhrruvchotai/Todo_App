import express from "express";
import Users from "../models/user_model.js";

const router = express.Router();

router.post("/signup", async (req,res) => {

    try{
        const {userName,email,password,confirmPassword} = req.body;

        if(!userName || !email || !password || !confirmPassword){
            res.status(400).json({message : "All fields are required!"});
        }

        if(password != confirmPassword){
            res.status(400).json({message : "Password and Confirm Password must be same!"});
        }

        const isUserExists = Users.findOne({email});

        if(!isUserExists){
            return res.status(400).json({message : "User with this email already exists!"});
        }

        const newUser = await Users.create({
            userName : userName,
            email : email,
            password : password,
        });

        if(newUser){
            console.log("Account created successfully!");
            res.status(201).json({message : "Account created successfully!",user : newUser});
        }
        else{
            res.status(400).json({message : "Error in creating user account!"});
        }
    }
    catch(e){
        console.log(`Error occurred while creating account.. ${e.message}`);
        res.status(500).json({message : "Error in registration!"});
    }
});

router.post("/login", async (req,res) => {
    try{
        const {email, password} = req.body;

        if(!email || !password){
            res.status(400).json({message : "All field are required!"});
        }

        const user = await Users.findOne({email});
        if(!user || !user.password){
            res.status(400).json({message : "Invalid credentials!"});
        }

        const isMatchingPassword = await user.matchPassword(password);

        if(!isMatchingPassword){
            return res.status(400).json({message : "Invalid credentials!"});
        }

        res.status(200).json({
            message: "Logged in successfully!",
            userId: user._id, // Send user ID back to the frontend
            user: user // Optional
        });

    }
    catch(e){
        console.log(`Error in logging in the account : ${e.message}`);
        res.status(500).json({message : "Error in logging in user account!"});
    }
});

export default router