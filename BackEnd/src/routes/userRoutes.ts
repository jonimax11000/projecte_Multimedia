import express from "express";
import { createUser, getUsers, getUserById } from "../controllers/userController.js";
import { authMiddleware } from "../middlewares/authMiddleware.js";

const userRouter = express.Router();


userRouter.get("/", getUsers); 
userRouter.get("/:id", getUserById);
userRouter.post("/", createUser);


// Protegim la ruta per 
//userRouter.post("/create", authMiddleware, createUser);

export default userRouter;