-- ###########################################################
-- #             PROJETO: FEIRA DE ORGÂNICOS                 #
-- #         SCRIPT SQL COMPLETO: MODELO FÍSICO,             #
-- #             CARGA DE DADOS E OPERAÇÕES DIVERSAS         #
-- ###########################################################


-- 4. MODELO FÍSICO (Comandos CREATE TABLE)
-- Criação do banco de dados e definição das tabelas com chaves primárias e estrangeiras.

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


-- 5. SCRIPTS SQL DE INSERÇÃO (Carga de Dados - Exemplo Reduzido)
-- Inserção de dados de exemplo nas tabelas.

INSERT INTO Produtor (nome, telefone, email, endereco) VALUES
('Fazenda Orgânica da Serra', '11987654321', 'contato@fazendaserra.com', 'Rua dos Pinheiros, 123, Zona Rural, SP'),
('Horta Viva', '21998765432', 'contato@hortaviva.com', 'Av. Central, 456, Bairro Verde, RJ');

INSERT INTO Produto (nome, tipo, unidade_venda) VALUES
('Maçã Gala', 'Fruta', 'kg'),
('Alface Crespa', 'Verdura', 'maço'),
('Cenoura Orgânica', 'Legume', 'kg');

INSERT INTO Produto_Produtor (id_produto, id_produtor, preco, quantidade_disponivel) VALUES
(1, 1, 9.50, 150),
(2, 1, 3.50, 80),
(3, 2, 6.00, 120);

INSERT INTO Consumidor (nome, telefone, email, endereco) VALUES
('Ana Silva', '11912345678', 'ana.silva@email.com', 'Rua da Paz, 10, Centro, SP'),
('Bruno Costa', '21987654321', 'bruno.c@email.com', 'Av. das Palmeiras, 200, Copacabana, RJ');

INSERT INTO Feira (data, local_entrega) VALUES
('2025-07-27', 'Parque da Cidade - Entrada Principal'),
('2025-08-03', 'Praça Central - Coreto');

INSERT INTO Pedido (id_consumidor, id_feira, data_pedido, status) VALUES
(1, 1, '2025-07-25', 'Entregue'),
(2, 1, '2025-07-26', 'Entregue'),
(1, 2, '2025-08-01', 'Pendente');

INSERT INTO Pedido_Produto (id_pedido, id_produto, id_produtor, quantidade) VALUES
(1, 1, 1, 2),
(1, 2, 1, 1),
(2, 3, 2, 3),
(3, 1, 1, 1);


-- 6. OPERAÇÕES DIVERSAS (Consultas SQL Obrigatórias)
-- Consultas para extração e análise de dados.

SELECT p.nome AS NomeProduto,p.tipo AS TipoProduto,p.unidade_venda AS UnidadeVenda,pp.preco AS Preco,pp.quantidade_disponivel AS QuantidadeDisponivel FROM Produto_Produtor pp JOIN Produto p ON pp.id_produto = p.id_produto JOIN Produtor pr ON pp.id_produtor = pr.id_produtor WHERE pr.nome = 'Fazenda Orgânica da Serra' ORDER BY NomeProduto;
SELECT ped.id_pedido,ped.data_pedido,ped.status,f.data AS DataFeira,f.local_entrega AS LocalEntregaFeira,p.nome AS NomeProduto,pr.nome AS NomeProdutor,pp.quantidade AS QuantidadePedida,(pp.quantidade * ppr.preco) AS SubtotalItem FROM Pedido_Produto pp JOIN Pedido ped ON pp.id_pedido = ped.id_pedido JOIN Consumidor c ON ped.id_consumidor = c.id_consumidor JOIN Feira f ON ped.id_feira = f.id_feira JOIN Produto p ON pp.id_produto = p.id_produto JOIN Produtor pr ON pp.id_produtor = pr.id_produtor JOIN Produto_Produtor ppr ON pp.id_produto = ppr.id_produto AND pp.id_produtor = ppr.id_produtor WHERE c.nome = 'Ana Silva' ORDER BY ped.data_pedido,ped.id_pedido,NomeProduto;
SELECT ped.id_pedido,c.nome AS NomeConsumidor,ped.data_pedido,ped.status,SUM(pp.quantidade * ppr.preco) AS ValorTotalPedido FROM Pedido_Produto pp JOIN Pedido ped ON pp.id_pedido = ped.id_pedido JOIN Produto_Produtor ppr ON pp.id_produto = ppr.id_produto AND pp.id_produtor = ppr.id_produtor JOIN Consumidor c ON ped.id_consumidor = c.id_consumidor GROUP BY ped.id_pedido,c.nome,ped.data_pedido,ped.status ORDER BY ped.id_pedido;
SELECT p.nome AS NomeProduto,p.tipo AS TipoProduto,SUM(pp.quantidade) AS QuantidadeTotalPedida FROM Pedido_Produto pp JOIN Pedido ped ON pp.id_pedido = ped.id_pedido JOIN Feira f ON ped.id_feira = f.id_feira JOIN Produto p ON pp.id_produto = p.id_produto WHERE f.data = (SELECT MAX(data) FROM Feira WHERE data <= CURDATE()) GROUP BY p.nome,p.tipo ORDER BY QuantidadeTotalPedida DESC LIMIT 5;
SELECT pr.nome AS NomeProdutor,f.data AS DataFeira,COUNT(DISTINCT ped.id_pedido) AS TotalPedidos FROM Produtor pr JOIN Produto_Produtor ppr ON pr.id_produtor = ppr.id_produtor JOIN Pedido_Produto pprod ON ppr.id_produto = pprod.id_produto AND ppr.id_produtor = pprod.id_produtor JOIN Pedido ped ON pprod.id_pedido = ped.id_pedido JOIN Feira f ON ped.id_feira = f.id_feira GROUP BY pr.nome,f.data HAVING COUNT(DISTINCT ped.id_pedido) > 3 ORDER BY TotalPedidos DESC;
