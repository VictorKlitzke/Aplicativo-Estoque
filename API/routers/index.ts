import express from "express";
import { login, registerInsumos } from "../controllers/post";
import { authUser } from "../middleware/auth";

const router = express.Router();

router.post("/login", login);
router.post("/registerinsumos", authUser, registerInsumos);

export default router;
