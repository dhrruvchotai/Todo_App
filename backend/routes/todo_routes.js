import express from "express"
import Todos from "../models/todo_model.js";

const router = express.Router();

//fetch all the todos from DB
router.get('/fetch/:userId',async(req,res) => {
    try{
        const {userId} = req.params;

        if(!userId){
            return res.status(400).json("User Id is required!");
        }

        const todos = await Todos.find({userId});
        console.log(`All Todos : ${todos}`);
        res.status(200).json(todos);
    }
    catch(e){
        console.log(`Error in fetching all todo route : ${e.message}`);
        res.status(500).json({message : "Error occurred in fetching all the todos!"});
    }
}); 

//add a todo to the DB
router.post('/add',async(req,res)=>{
    try{
        const{userId, title, description, priority} = req.body;

        console.log(`User ID : ${userId}, Title : ${title}, Description : ${description}, Priority : ${priority}`);

        if(!userId || !title){
            res.status(400).json({message : "User ID and Title is necessary!"})
        }
        else{
            //create method create a new object of the model and saves it automatically to DB
            const newTodo = await Todos.create({
                userId : userId,
                title : title,
                description : description,
                priority : priority,
            });

            if(newTodo){
                console.log(`Todo added : ${newTodo}`);
                res.status(201).json({message : "Todo added successfully!",data : newTodo});
            }
            else{
                res.status(500).json({message : "Failed to added todo!"})
            }
        }
    }
    catch(e){
        console.log(`Error in adding todo route : ${e.message}`);
        res.status(500).json({message : "Error occurred while adding data to the DB."})
    }
});

//edit a todo 
router.patch('/edit/:id',async(req,res)=>{
    try{
        const{userId, title, description, priority} = req.body;
        
        if(!req.params.id || !userId || !title){
            res.status(400).json({message : "User ID, Todo ID and title is necessary - can not update the data!"});
        }
        else{
            const updatedTodo = await Todos.findOneAndUpdate(
                {id : req.params.id,userId : userId},
                {title : title, description : description, priority : priority},
                //it returns the updated the document
                {new : true}
            );

            if(updatedTodo){
                console.log(`Updated Todo : ${updatedTodo}`);
                res.status(200).json({message : "Todo updated successfully!",data : updatedTodo});
            }
            else{
                res.status(500).json({message : "Failed to update todo!"});
            }
        }
    }
    catch(e){
        console.log(`Error in updating todo route : ${e.message}`);
        res.status(500).json({message : "Error occurred while updating the todo!"});
    }
});

//delete a todo
router.delete('/delete/:id',async(req,res) => {
    try{
        const {userId} = req.body;

        if(!req.params.id || !userId){
            return res.status(400).json({message : "User ID and Todo ID are required!"});
        }

        const deletedTodo = await Todos.findOneAndDelete({id : req.params.id,userId : userId});

        if(deletedTodo){
            res.status(200).json({message : "Todo deleted successfully!"});
        }
        else{
            res.status(500).json({message : "Failed to delete todo!"});
        }
    }
    catch(e){
        console.log(`Error in deleting todo route : ${e.message}`);
        res.status(500).json({message : "Error in deleting a todo!"});
    }
});

export default router;