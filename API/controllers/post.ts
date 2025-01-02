import {Request, Response} from "express";
import pool from "../database/index";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from 'dotenv'

dotenv.config();

interface User {
    id: number;
    nome: string;
    senha: string
}

interface Insumos {
    id: number;
    nome: string;
    categoria: string;
    quantidade: number;
    estoque_minimo: number;
    custo_unitario: number;
}

export const registerInsumos = async (req: Request, res: Response): Promise<void> => {
    // @ts-ignore
    const {data} = req.body;

    // @ts-ignore
    const {nome, categoria, quantidade, unidade, estoqueMinimo, custoUnitario} = data;

    if (!nome || !categoria || !quantidade || !unidade || !estoqueMinimo || !custoUnitario) {
        res.status(400).json({message: "Campos incorretos"});
        return;
    }
    try {
        const query = `
            INSERT INTO insumos (nome, categoria, quantidade, unidade, estoque_minimo, custo_unitario)
            VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;
        `;

        const values = [nome, categoria, quantidade, unidade, estoqueMinimo, custoUnitario];

        const result = await pool.run(query, values);

        res.status(201).json({
            message: "Insumo registrado com sucesso",
            insumosId: result,
        });

    } catch (error) {
        console.error("Error durante o registro:", error);
        res.status(500).json({message: "Internal server error"});
    }
}

export const login = async (req: Request, res: Response): Promise<void> => {
    const {username, password}: { username: string; password: string } = req.body;

    if (!username || !password) {
        res.status(400).json({message: "Usuário e senha incorretas"});
        return;
    }

    try {
        pool.get("SELECT * FROM usuarios WHERE nome = ?", [username], async (err: Error | null, user: User | undefined) => {
            if (err) {
                console.error("Erro na consulta ao banco:", err.message);
                return res.status(500).json({error: "Erro interno no servidor"});
            }

            if (!user) {
                return res.status(401).json({error: "Usuário ou senha inválidos"});
            }

            const adjustedHash = user.senha.replace("$2y$", "$2a$");
            const isPasswordValid = await bcrypt.compare(password, adjustedHash);
            if (!isPasswordValid) {
                return res.status(401).json({error: "Senha incorreta"});
            }

            const secret = process.env.TOKEN;
            if (!secret) {
                console.error("TOKEN não definido no arquivo .env");
                res.status(500).json({error: "Erro de configuração do servidor"});
                return;
            }

            const token = jwt.sign({id: user.id}, secret, {expiresIn: "3h"});

            res.cookie("token", token, {
                httpOnly: true,
                secure: false,
                sameSite: "lax",
                maxAge: 18000000,
            });

            return res.json({
                authorization: true,
                token: token,
                message: "Login realizado com sucesso",
                UserId: user.id
            });
        })

    } catch (error) {
        console.error("Error durante o login:", error);
        res.status(500).json({message: "Internal server error"});
    }
}
