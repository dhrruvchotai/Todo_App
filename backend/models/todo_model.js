import mongoose from "mongoose"
import AutoIncrementFactory from "mongoose-sequence"
import dotenv from 'dotenv';

dotenv.config()

const connection = mongoose.createConnection(process.env.CONNECTION_STRING);
const AutoIncrement = AutoIncrementFactory(connection);

const todoSchema = new mongoose.Schema(
    {
        id:{
            type : Number,
            unique : true
        },
        title:{
            type : String,
            required : true,
            trim : true,
        },
        description:{
            type : String,
            trim : true
        },
    },
    {
        timestamps : true,
        
    }
);

todoSchema.plugin(AutoIncrement, {inc_field : "id"});

const Todos = mongoose.model("Todos",todoSchema);
export default Todos;