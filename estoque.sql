/*Para criar um banco de dados de estoque, você pode seguir as seguintes etapas:

Crie uma tabela de produtos com os seguintes campos: id, nome, descrição e quantidade.*/

CREATE TABLE produtos (
  id INT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  descricao VARCHAR(255),
  quantidade INT NOT NULL
);


/* Crie uma tabela de fornecedores com os seguintes campos: id, nome, e-mail e telefone.*/

CREATE TABLE fornecedores (
  id INT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  email VARCHAR(255) UNIQUE,
  telefone VARCHAR(20)
);


/*Crie uma tabela de compras com os seguintes campos: id, data, id_produto, id_fornecedor e quantidade */

CREATE TABLE compras (
  id INT PRIMARY KEY,
  data DATE NOT NULL,
  id_produto INT NOT NULL,
  id_fornecedor INT NOT NULL,
  quantidade INT NOT NULL,
  FOREIGN KEY (id_produto) REFERENCES produtos(id),
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id)
);


/* Crie uma tabela de vendas com os seguintes campos: id, data, id_produto e quantidade. */

CREATE TABLE vendas (
  id INT PRIMARY KEY,
  data DATE NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

/*Com as tabelas criadas, agora você pode inserir alguns dados de exemplo para fazer consultas SQL: */ 

INSERT INTO produtos (id, nome, descricao, quantidade) VALUES
  (1, 'Camiseta', 'Camiseta de algodão', 100),
  (2, 'Calça', 'Calça jeans', 50),
  (3, 'Sapato', 'Sapato social', 25);

INSERT INTO fornecedores (id, nome, email, telefone) VALUES
  (1, 'Fornecedor A', 'fornecedorA@example.com', '999999999'),
  (2, 'Fornecedor B', 'fornecedorB@example.com', '888888888');

INSERT INTO compras (id, data, id_produto, id_fornecedor, quantidade) VALUES
  (1, '2023-03-15', 1, 1, 50),
  (2, '2023-03-16', 2, 2, 25),
  (3, '2023-03-17', 3, 1, 10),
  (4, '2023-03-18', 1, 2, 30);

INSERT INTO vendas (id, data, id_produto, quantidade) VALUES
  (1, '2023-03-16', 1, 10),
  (2, '2023-03-17', 2, 5),
  (3, '2023-03-18', 1, 15),
  (4, '2023-03-18', 3, 5);


/* Agora, você pode usar consultas SQL para gerenciar o estoque:

Adicionar um novo produto: */

INSERT INTO produtos (id, nome, descricao, quantidade) VALUES
  (4, 'Boné', 'Boné com logotipo da empresa', 20);

/*Atualizar a quantidade de um produto existente: */

UPDATE produtos SET quantidade = quantidade + 10 WHERE id = 2;


/* Excluir um produto do estoque */ 

DELETE FROM produtos WHERE id = 3;

/*Verificar o estoque atual:*/

SELECT nome, quantidade FROM produtos;


/* Verificar o histórico de vendas de um produto: */ 

SELECT data, quantidade FROM vendas WHERE id_produto = 1;


/* Verificar as compras de um fornecedor: */ 

SELECT data, nome, quantidade FROM compras
JOIN fornecedores ON compras.id_fornecedor = fornecedores.id
WHERE fornecedores.nome = 'Fornecedor A';

/* Verificar os produtos mais vendidos: */ 

SELECT produtos.nome, SUM(vendas.quantidade) AS total_vendido FROM vendas
JOIN produtos ON vendas.id_produto = produtos.id
GROUP BY produtos.nome
ORDER BY total_vendido DESC;

/* Verificar o período de tempo com mais vendas */ 

SELECT YEAR(data) AS ano, MONTH(data) AS mes, SUM(quantidade) AS total_vendido FROM vendas
GROUP BY YEAR(data), MONTH(data)
ORDER BY total_vendido DESC;

/* Verificar a movimentação de estoque de um determinado produto: */ 

SELECT 
    estoque.data_movimentacao,
    estoque.tipo_movimentacao,
    estoque.quantidade,
    produtos.nome AS produto,
    funcionarios.nome AS funcionario
FROM 
    estoque 
    JOIN produtos ON estoque.id_produto = produtos.id 
    JOIN funcionarios ON estoque.id_funcionario = funcionarios.id
WHERE 
    produtos.nome = 'Produto A'
ORDER BY 
    estoque.data_movimentacao DESC;

/* Essa consulta mostra todas as movimentações de estoque do Produto A,
 incluindo o tipo de movimentação (entrada ou saída), a quantidade movimentada,
 a data e hora da movimentação, o nome do produto e o nome do 
 funcionário que realizou a movimentação.*/


/*Verificar o estoque atual de cada produto em cada loja:*/

SELECT 
    produtos.nome AS produto,
    lojas.nome AS loja,
    estoque.quantidade
FROM 
    estoque 
    JOIN produtos ON estoque.id_produto = produtos.id 
    JOIN lojas ON estoque.id_loja = lojas.id
ORDER BY 
    produtos.nome, lojas.nome;

/* Essa consulta mostra o estoque atual de cada produto em cada loja, ordenado pelo nome do produto e o nome da loja.

Verificar o estoque mínimo de cada produto: */

SELECT 
    produtos.nome AS produto,
    estoque_minimo.quantidade_minima AS estoque_minimo
FROM 
    produtos 
    JOIN estoque_minimo ON produtos.id = estoque_minimo.id_produto;


/* Essa consulta mostra o estoque mínimo de cada produto, que pode ser usado para gerenciar as compras e reposições de estoque.

Verificar a quantidade de vendas por categoria de produto: */

SELECT 
    categorias.nome AS categoria,
    SUM(vendas.quantidade) AS total_vendido
FROM 
    vendas 
    JOIN produtos ON vendas.id_produto = produtos.id
    JOIN categorias ON produtos.id_categoria = categorias.id
GROUP BY 
    categorias.nome
ORDER BY 
    total_vendido DESC;

/* Essa consulta mostra a quantidade total de vendas de cada categoria de produto, 
ordenada pelo número de vendas decrescente. Isso pode ajudar a 
identificar quais categorias são mais populares entre os clientes e
 ajustar o estoque de acordo.*/ 

