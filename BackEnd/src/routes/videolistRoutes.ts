import express from "express";
import { getVideos,getVideosPerId,getVideosPerThumbnail} from "../controllers/videoController.js";
import { authMiddleware } from "../middlewares/authMiddleware.js";
import { get } from "http";

const userRouter = express.Router();


userRouter.get("/", getVideos); 
userRouter.get("/:id", getVideosPerId);
userRouter.get("/:topic", getVideosPerThumbnail);


// Protegim la ruta per 
//userRouter.post("/create", authMiddleware, createUser);

export default userRouter;