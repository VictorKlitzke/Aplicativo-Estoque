export interface Insumos {
    id: number;
    nome: string;
    categoria: string;
    quantidade: number;
    unidade: string;
    estoque_minimo: number;
    custo_unitario: number;
}

export interface User {
    id: number;
    nome: string;
    senha: string
}


