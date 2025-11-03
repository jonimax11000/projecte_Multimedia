import express from "express";
import { getVideos,getVideosPerId,} from "../controllers/videoController.js";
import { authMiddleware } from "../middlewares/authMiddleware.js";

const userRouter = express.Router();


userRouter.get("/", getUsers); 
userRouter.get("/:id", getUserById);
userRouter.get("/:topic", createUser);


// Protegim la ruta per 
//userRouter.post("/create", authMiddleware, createUser);

export default userRouter;