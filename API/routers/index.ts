import express from "express";
import {login, registerInsumos} from "../controllers/post";
import {getInsumos, getMovimentacoes} from "../controllers/get";
import {authUser} from "../middleware/auth";

const router = express.Router();

router.post("/login", login);
router.post("/registerinsumos", authUser, registerInsumos);


router.get("/getInsumos", authUser, getInsumos);
router.get("/getMovimentacoes", authUser, getMovimentacoes);

export default router;
