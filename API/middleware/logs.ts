import pool from "../database";
import {Request, Response} from "express";

export const logs = async (message: string, type: string, userId: number): Promise<void> => {

    try {

        const query = pool.prepare("INSERT INTO logs (mensagem, tipo, usuario_id, data) VALUES(?,?,?,?)")
        const result = query.run(message, type, userId, new Date());

        // res.status(200).json({ message: "Log registrado com sucesso", result });

    } catch (error) {
        console.error("Error durante os logs:", error);
    }
}