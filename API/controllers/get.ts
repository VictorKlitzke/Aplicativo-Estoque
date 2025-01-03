import {Request, Response} from "express";
import pool from "../database/index";
import dotenv from 'dotenv'
import {Insumos} from "../interface";

dotenv.config();

export const getInsumos = async (req: Request, res: Response): Promise<void> => {
    try {
        // const userId = (req as any).user.id;

        pool.all("SELECT * FROM insumos", async (err: Error, rows: Insumos) => {
            if (err) {
                console.error('Erro na consulta:', err);
                return res.status(500).json({ message: 'Erro interno no servidor', error: err.message });
            }

            return res.status(200).json({ getInsumos: rows });
        })

    } catch (error) {
        console.error('Erro na consulta:', error);
        res.status(500).json({ message: 'Erro interno no servidor', error: (error as Error).message });
    }
}

export const getMovimentacoes = async (req: Request, res: Response): Promise<void> => {
    try {
        // const userId = (req as any).user.id;

        pool.all("SELECT * FROM movimentacoes", async (err: Error, rows: Insumos) => {
            if (err) {
                console.error('Erro na consulta:', err);
                return res.status(500).json({ message: 'Erro interno no servidor', error: err.message });
            }

            return res.status(200).json({ getMovimentacoes: rows });
        })

    } catch (error) {
        console.error('Erro na consulta:', error);
        res.status(500).json({ message: 'Erro interno no servidor', error: (error as Error).message });
    }
}