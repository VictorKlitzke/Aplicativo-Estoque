import sqlite3 from "sqlite3";
import path from "node:path";

const dbPath: string = path.resolve(__dirname, './EstoqueInsumos.db');

const pool = new sqlite3.Database(dbPath, (err: Error | null) => {
    if (err) {
        console.error("Erro ao conectar ao banco de dados SQLite:", err.message);
    } else {
        console.log("Conectado ao banco de dados SQLite com sucesso!");
    }
})

export default pool;