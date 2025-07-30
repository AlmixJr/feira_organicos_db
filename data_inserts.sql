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