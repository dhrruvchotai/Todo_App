import express from "express"
import mongoose from "mongoose"
import dotenv from "dotenv"
import todo_routes from "./routes/todo_routes.js"
import auth_routes from "./routes/auth_routes.js"
import cors from "cors";

const app = express();
dotenv.config();

app.use(cors({}));
app.use(express.json());

//todo routes
app.use('/user/api/todos',todo_routes);

//auth routes
app.use('/user/api/auth',auth_routes);

//mongoDB url
const mongoDBUrl = process.env.CONNECTION_STRING


//connection with mongoDB
mongoose.connect(mongoDBUrl).then(
    ()=>{
        console.log("Successfully connected with DB")

        app.listen(process.env.PORT, ()=>{
            console.log(`Server is running on port ${process.env.PORT}`)
        });
   }
);

