CREATE DATABASE IF NOT EXISTS feira_organicos
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE feira_organicos;

CREATE TABLE Produtor (
    id_produtor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(200)
);

CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    unidade_venda ENUM('kg', 'maço', 'unidade') NOT NULL,
    UNIQUE (nome, tipo)
);

CREATE TABLE Produto_Produtor (
    id_produto INT NOT NULL,
    id_produtor INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_disponivel INT NOT NULL,
    PRIMARY KEY (id_produto, id_produtor),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_produtor) REFERENCES Produtor(id_produtor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Consumidor (
    id_consumidor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(200)
);

CREATE TABLE Feira (
    id_feira INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    local_entrega VARCHAR(200) NOT NULL
);

CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_consumidor INT NOT NULL,
    id_feira INT NOT NULL,
    data_pedido DATE NOT NULL,
    status ENUM('Pendente', 'Confirmado', 'Preparado', 'Entregue', 'Cancelado') NOT NULL DEFAULT 'Pendente',
    FOREIGN KEY (id_consumidor) REFERENCES Consumidor(id_consumidor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_feira) REFERENCES Feira(id_feira)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Pedido_Produto (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    id_produtor INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (id_pedido, id_produto, id_produtor),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_produtor) REFERENCES Produtor(id_produtor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_produto_produtor FOREIGN KEY (id_produto, id_produtor)
        REFERENCES Produto_Produtor(id_produto, id_produtor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);