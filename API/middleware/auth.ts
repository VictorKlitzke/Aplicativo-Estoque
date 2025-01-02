import {Request, Response, NextFunction} from "express";
import jwt, {JwtPayload} from "jsonwebtoken";
import pool from "../database/index";


interface User {
    id: number;
    nome: string;
    senha: string
}

export const authUser = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    let token: string | undefined = req.cookies['token'];

    if (!token && req.headers['authorization']) {
        const authHeader = req.headers['authorization'];
        token = authHeader.split(' ')[1];
    }

    if (!token) {
        res.status(401).json({message: '[AVISO] - TOKEN NÃO INFORMADO'});
        return;
    }

    const secretKey = process.env.TOKEN;
    if (!secretKey) {
        throw new Error('Secret key not defined in environment variables');
    }

    try {

        const decoded = jwt.verify(token, secretKey) as JwtPayload;
        const userId = decoded.id;

        pool.get("SELECT * FROM usuarios WHERE id = ?", [userId], async (error: Error | null, user: User | undefined) => {
            if (error) {
                console.error('[AVISO] - ERRO AO CONSULTAR USUÁRIO:', error);
                return res.status(500).json({message: '[AVISO] - ERRO INTERNO DO SERVIDOR'});
            }

            if (!user) {
                return res
                    .status(404)
                    .json({message: '[AVISO] - USUÁRIO NÃO ENCONTRADO'});
            }

            (req as any).user = user;
            next();
        })
    } catch (error) {
        if (error instanceof jwt.JsonWebTokenError) {
            res.status(403).json({message: '[AVISO] - AUTENTICAÇÃO NÃO VALIDADA'});
        } else {
            console.error('[AVISO] - ERRO AO VERIFICAR USUÁRIO:', error);
            res.status(500).json({message: '[AVISO] - ERRO INTERNO DO SERVIDOR'});
        }
    }
};