--> TABLES
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PBL')
BEGIN
    CREATE DATABASE PBL;
END
GO
USE PBL;
GO

CREATE TABLE Usuarios (
    Id INT PRIMARY KEY, 
    Login NVARCHAR(50) UNIQUE NOT NULL,
    Senha NVARCHAR(255) NOT NULL,
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    DataNascimento DATE,
    Telefone NVARCHAR(20),
    DataRegistro DATETIME NOT NULL DEFAULT GETDATE()
);
GO
CREATE TABLE Empresas (
    Id INT PRIMARY KEY, 
    NomeEmpresa NVARCHAR(150) NOT NULL,
    CNPJ NVARCHAR(20) NOT NULL UNIQUE,
    CEP NVARCHAR(9) NOT NULL,
    Logradouro NVARCHAR(255) NOT NULL,
	Numero int NOT NULL,
    Cidade NVARCHAR(255) NOT NULL,
    Estado NVARCHAR(2) NOT NULL,
    Telefone NVARCHAR(20),
    Email NVARCHAR(100),
    DataCadastro DATETIME NOT NULL DEFAULT GETDATE()
);

GO
CREATE TABLE Estufas (
    Id INT PRIMARY KEY, 
    IdUsuario INT NOT NULL,
    IdEmpresa INT NOT NULL,    
    Modelo NVARCHAR(50) NOT NULL,    
    Descricao NVARCHAR(255) NULL,
    Preco MONEY,
    PeriodoLocacao INT NOT NULL CHECK (PeriodoLocacao > 0),
    DataCadastro DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (IdEmpresa) REFERENCES Empresas(Id) ON DELETE CASCADE,
    FOREIGN KEY (IdUsuario) REFERENCES Usuarios(Id) ON DELETE CASCADE
);
GO
--> PROCEDURES GENERICAS

create or alter procedure spDelete
(
 @id int ,
 @tabela varchar(max)
)
as
begin
 declare @sql varchar(max);
 set @sql = ' delete ' + @tabela +
 ' where id = ' + cast(@id as varchar(max))
 exec(@sql)
end
GO

create or alter procedure spConsulta
(
 @id int ,
 @tabela varchar(max)
)
as
begin
 declare @sql varchar(max);
 set @sql = 'select * from ' + @tabela +
 ' where id = ' + cast(@id as varchar(max))
 exec(@sql)
end
GO

create or alter procedure spListagem
(
 @tabela varchar(max),
 @ordem varchar(max))
as
begin
 exec('select * from ' + @tabela +
 ' order by ' + @ordem)
end
GO

create OR ALTER procedure spProximoId
(@tabela varchar(max))
as
begin
 exec('select isnull(max(id) +1, 1) as MAIOR from '
 +@tabela)
end
GO

--> PROCEDURES ESPECIFICAS 
--> ESTUFAS	 
CREATE PROCEDURE spInsert_Estufas
(
    @Id INT,
    @IdUsuario INT,
    @IdEmpresa INT,
    @Modelo NVARCHAR(50),
    @Descricao NVARCHAR(255) = NULL,
    @Preco MONEY,
    @PeriodoLocacao INT,
    @DataCadastro DATETIME = NULL
)
AS
BEGIN
    IF @DataCadastro IS NULL
        SET @DataCadastro = GETDATE();

    INSERT INTO Estufas
    (Id, IdUsuario, IdEmpresa, Modelo, Descricao, Preco, PeriodoLocacao, DataCadastro)
    VALUES
    (@Id, @IdUsuario, @IdEmpresa, @Modelo, @Descricao, @Preco, @PeriodoLocacao, @DataCadastro);
END
GO

CREATE or alter PROCEDURE spUpdate_Estufas
(
    @id INT,
    @IdUsuario INT,
    @IdEmpresa INT,
    @Modelo NVARCHAR(50),
    @Descricao NVARCHAR(255) = NULL,
    @Preco MONEY,
    @PeriodoLocacao INT,
    @DataCadastro DATETIME
)
AS
BEGIN
    UPDATE Estufas
    SET 
        IdUsuario = @IdUsuario,
        IdEmpresa = @IdEmpresa,
        Modelo = @Modelo,
        Descricao = @Descricao,
        Preco = @Preco,
        PeriodoLocacao = @PeriodoLocacao,
        DataCadastro = @DataCadastro
    WHERE id = @id;
END
GO

--> USUÁRIOS
CREATE or alter PROCEDURE spInsert_Usuarios
(
    @Id INT, 
    @Login NVARCHAR(50),
    @Senha NVARCHAR(255),
    @Nome NVARCHAR(100),
    @Email NVARCHAR(100),
    @DataNascimento DATE = NULL,
    @Telefone NVARCHAR(20) = NULL,
    @DataRegistro DATETIME = NULL
)
AS
BEGIN
    IF @DataRegistro IS NULL
        SET @DataRegistro = GETDATE();

    INSERT INTO Usuarios
    (Id, Login, Senha, Nome, Email, DataNascimento, Telefone, DataRegistro)
    VALUES
    (@Id, @Login, @Senha, @Nome, @Email, @DataNascimento, @Telefone, @DataRegistro);
END
GO

CREATE or alter PROCEDURE spUpdate_Usuarios
(
    @Id INT,
    @Login NVARCHAR(50),
    @Senha NVARCHAR(255),
    @Nome NVARCHAR(100),
    @Email NVARCHAR(100),
    @DataNascimento DATE = NULL,
    @Telefone NVARCHAR(20) = NULL,
    @DataRegistro DATETIME = NULL
)
AS
BEGIN
    UPDATE Usuarios
    SET 
        Login = @Login,
        Senha = @Senha,
        Nome = @Nome,
        Email = @Email,
        DataNascimento = @DataNascimento,
        Telefone = @Telefone,
        DataRegistro = ISNULL(@DataRegistro, DataRegistro) -- Mantém o valor atual se não for passado um novo valor
    WHERE Id = @Id;
END
GO

CREATE OR ALTER PROCEDURE spChecaUsuario
(       
    @Login NVARCHAR(100),
    @Senha NVARCHAR(100)
)
AS
BEGIN
	select * from Usuarios
	where login = @Login and senha = @Senha
END
GO

--> Empresas

CREATE OR ALTER PROCEDURE spInsert_Empresas
(
    @Id INT, 
    @NomeEmpresa NVARCHAR(150),
    @CNPJ NVARCHAR(20),
    @CEP NVARCHAR(9),
    @Logradouro NVARCHAR(255),
	@Numero int,
    @Cidade NVARCHAR(255),
    @Estado NVARCHAR(2),
    @Telefone NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @DataCadastro DATETIME = NULL
)
AS
BEGIN
    IF @DataCadastro IS NULL
        SET @DataCadastro = GETDATE();

    INSERT INTO Empresas
    (Id, NomeEmpresa, CNPJ, CEP, Logradouro, Numero, Cidade, Estado, Telefone, Email, DataCadastro)
    VALUES
    (@Id, @NomeEmpresa, @CNPJ, @CEP, @Logradouro,@Numero, @Cidade, @Estado, @Telefone, @Email, @DataCadastro);
END
GO


CREATE OR ALTER PROCEDURE spUpdate_Empresas
(
    @Id INT,
    @NomeEmpresa NVARCHAR(150),
    @CNPJ NVARCHAR(20),
    @CEP NVARCHAR(9),
    @Logradouro NVARCHAR(255),
	@Numero int,
    @Cidade NVARCHAR(255),
    @Estado NVARCHAR(2),
    @Telefone NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @DataCadastro DATETIME = NULL
)
AS
BEGIN
    UPDATE Empresas
    SET 
        NomeEmpresa = @NomeEmpresa,
        CNPJ = @CNPJ,
        CEP = @CEP,
        Logradouro = @Logradouro,
		Numero = @Numero,
        Cidade = @Cidade,
        Estado = @Estado,
        Telefone = @Telefone,
        Email = @Email,
        DataCadastro = ISNULL(@DataCadastro, DataCadastro) -- Mantém o valor atual se não for passado um novo valor
    WHERE Id = @Id;
END

GO
--Create Consulta Avançada
Create or ALTER   procedure [dbo].[spConsultaAvancada]
(
 @nomeUsuario varchar(max),
 @nomeEmpresa varchar(max),
 @nomeEstufa varchar(max)
)
as
begin
	IF @nomeUsuario = '' AND @nomeEmpresa = '' AND @nomeEstufa = ''
	BEGIN
		SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Estufas
        FULL JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        FULL JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
    END
  -- Caso apenas @nomeUsuario seja preenchido
    IF @nomeEmpresa = '' AND @nomeEstufa = ''
    BEGIN
        SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Usuarios
        FULL JOIN Estufas ON Usuarios.Id = Estufas.IdUsuario
        FULL JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
        WHERE Usuarios.Nome LIKE '%' + @nomeUsuario + '%';
    END
    -- Caso apenas @nomeEmpresa seja preenchido
    ELSE IF @nomeUsuario = '' AND @nomeEstufa = ''
    BEGIN
        SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Empresas
		FULL JOIN Estufas ON Empresas.Id = Estufas.IdEmpresa
        FULL JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        WHERE Empresas.NomeEmpresa LIKE '%' + @nomeEmpresa + '%';
    END
    -- Caso apenas @nomeEstufa seja preenchido
    ELSE IF @nomeUsuario = '' AND @nomeEmpresa = ''
    BEGIN
        SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Estufas
        FULL JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        FULL JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
        WHERE Estufas.Descricao LIKE '%' + @nomeEstufa + '%';
    END
    -- Caso @nomeEmpresa e @nomeEstufa sejam preenchidos
    ELSE IF @nomeUsuario = ''
    BEGIN
        SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Estufas
        FULL JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        FULL JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
        WHERE Empresas.NomeEmpresa LIKE '%' + @nomeEmpresa + '%'
          AND Estufas.Descricao LIKE '%' + @nomeEstufa + '%';
    END
    -- Caso @nomeUsuario e @nomeEmpresa sejam preenchidos
    ELSE IF @nomeEstufa = ''
    BEGIN
        SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Usuarios
        FULL JOIN Estufas ON Usuarios.Id = Estufas.IdUsuario
        FULL JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
        WHERE Usuarios.Nome LIKE '%' + @nomeUsuario + '%'
          AND Empresas.NomeEmpresa LIKE '%' + @nomeEmpresa + '%';
    END
    -- Caso @nomeUsuario e @nomeEstufa sejam preenchidos
    ELSE IF @nomeEmpresa = ''
    BEGIN
        SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Estufas
        FULL JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        FULL JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
        WHERE Usuarios.Nome LIKE '%' + @nomeUsuario + '%'
          AND Estufas.Descricao LIKE '%' + @nomeEstufa + '%';
    END
    -- Caso todos os parâmetros sejam preenchidos
    ELSE
    BEGIN
        SELECT	Estufas.Modelo as Modelo,
				Estufas.Descricao as Descrição,
				Estufas.Preco as Preço,
				Estufas.PeriodoLocacao as Período,
				Usuarios.Nome as Nome,
				Usuarios.Email as Email,
				Usuarios.Telefone as Telefone,
				Empresas.NomeEmpresa as Empresa,
				Empresas.CNPJ as CNPJ,
				Empresas.CEP as CEP,
				Empresas.Logradouro as Logradouro,
				Empresas.Numero as Numero,
				Empresas.Cidade as Cidade,
				Empresas.Estado as Estado
        FROM Estufas
        FULL JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        FULL JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
        WHERE Usuarios.Nome LIKE '%' + @nomeUsuario + '%'
        AND Empresas.NomeEmpresa LIKE '%' + @nomeEmpresa + '%'
        AND Estufas.Descricao LIKE '%' + @nomeEstufa + '%';
	END
end

GO
CREATE OR ALTER PROCEDURE spObterTotais
AS
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM Usuarios) AS TotalUsuarios,
        (SELECT COUNT(*) FROM Empresas) AS TotalEmpresas,
        (SELECT COUNT(*) FROM Estufas) AS TotalEstufas;
END;

GO
INSERT INTO Usuarios (Id, Login, Senha, Nome, Email, DataNascimento, Telefone) VALUES
(1, 'rosalem', 'programa', 'Rosalem', 'rosalem@gmail.com', '1990-05-15', '11999998888'),
(2, 'marcones', 'automacao', 'Marcones', 'marcones@gmail.com', '1990-03-22', '11988887777'),
(3, 'pedro.almeida', 'senha789', 'Pedro Almeida', 'pedro.almeida@gmail.com', '1992-08-12', '11977776666'),
(4, 'ana.oliveira', 'senha321', 'Ana Oliveira', 'ana.oliveira@gmail.com', '1995-12-01', '11966665555'),
(5, 'carlos.mendes', 'senha654', 'Carlos Mendes', 'carlos.mendes@gmail.com', '1988-07-18', '11955554444'),
(6, 'luiza.lima', 'senha987', 'Luiza Lima', 'luiza.lima@gmail.com', '1993-04-27', '11944443333'),
(7, 'felipe.costa', 'senha147', 'Felipe Costa', 'felipe.costa@gmail.com', '1991-10-10', '11933332222'),
(8, 'camila.rocha', 'senha258', 'Camila Rocha', 'camila.rocha@gmail.com', '1990-11-05', '11922221111'),
(9, 'lucas.martins', 'senha369', 'Lucas Martins', 'lucas.martins@gmail.com', '1994-06-16', '11911110000'),
(10, 'diana.ferreira', 'senha741', 'Diana Ferreira', 'diana.ferreira@gmail.com', '1987-09-09', '11900009999'),
(11, 'renata.lopes', 'senha852', 'Renata Lopes', 'renata.lopes@gmail.com', '1986-02-19', '1188887777'),
(12, 'andre.souza', 'senha963', 'André Souza', 'andre.souza@gmail.com', '1989-08-30', '1187776666'),
(13, 'juliana.ferraz', 'senha741', 'Juliana Ferraz', 'juliana.ferraz@gmail.com', '1991-06-12', '1186665555'),
(14, 'marcos.dias', 'senha321', 'Marcos Dias', 'marcos.dias@gmail.com', '1987-11-20', '1185554444'),
(15, 'natalia.ribeiro', 'senha852', 'Natália Ribeiro', 'natalia.ribeiro@gmail.com', '1993-03-25', '1184443333'),
(16, 'roberto.azevedo', 'senha123', 'Roberto Azevedo', 'roberto.azevedo@gmail.com', '1990-05-14', '1183332222'),
(17, 'fernanda.lima', 'senha456', 'Fernanda Lima', 'fernanda.lima@gmail.com', '1988-09-29', '1182221111'),
(18, 'vinicius.cardoso', 'senha789', 'Vinícius Cardoso', 'vinicius.cardoso@gmail.com', '1992-01-19', '1181110000'),
(19, 'paula.pereira', 'senha321', 'Paula Pereira', 'paula.pereira@gmail.com', '1994-07-10', '1180009999'),
(20, 'rafael.gomes', 'senha654', 'Rafael Gomes', 'rafael.gomes@gmail.com', '1985-12-05', '1179998888'),
(21, 'luciana.costa', 'senha963', 'Luciana Costa', 'luciana.costa@gmail.com', '1986-11-07', '1178887777'),
(22, 'daniel.silveira', 'senha147', 'Daniel Silveira', 'daniel.silveira@gmail.com', '1993-08-21', '1177776666'),
(23, 'aline.barros', 'senha258', 'Aline Barros', 'aline.barros@gmail.com', '1990-03-30', '1176665555'),
(24, 'ricardo.oliveira', 'senha369', 'Ricardo Oliveira', 'ricardo.oliveira@gmail.com', '1991-10-16', '1175554444'),
(25, 'patricia.martins', 'senha741', 'Patrícia Martins', 'patricia.martins@gmail.com', '1994-01-25', '1174443333'),
(26, 'gustavo.alves', 'senha852', 'Gustavo Alves', 'gustavo.alves@gmail.com', '1987-09-18', '1173332222'),
(27, 'carla.santos', 'senha963', 'Carla Santos', 'carla.santos@gmail.com', '1989-02-11', '1172221111'),
(28, 'bernardo.lima', 'senha147', 'Bernardo Lima', 'bernardo.lima@gmail.com', '1992-12-23', '1171110000'),
(29, 'heloisa.rocha', 'senha258', 'Heloísa Rocha', 'heloisa.rocha@gmail.com', '1995-05-15', '1170009999'),
(30, 'adriano.ribeiro', 'senha369', 'Adriano Ribeiro', 'adriano.ribeiro@gmail.com', '1990-10-07', '1179998888');

GO
INSERT INTO Empresas (Id, NomeEmpresa, CNPJ, CEP, Logradouro, Numero, Cidade, Estado, Telefone, Email) VALUES
(1, 'AgroTech Solutions', '12345678000101', '12345678', 'Rua das Palmeiras', 100, 'São Paulo', 'SP', '1133334444', 'contato@agrotech.com'),
(2, 'Green Farm', '23456789000102', '23456789', 'Avenida Brasil', 200, 'Rio de Janeiro', 'RJ', '2133335555', 'contato@greenfarm.com'),
(3, 'EcoGrow', '34567890000103', '34567890', 'Alameda Santos', 300, 'Belo Horizonte', 'MG', '3133336666', 'contato@ecogrow.com'),
(4, 'PlantTech', '45678901000104', '45678901', 'Rua das Flores', 400, 'Curitiba', 'PR', '4133337777', 'contato@planttech.com'),
(5, 'BioFarm', '56789012000105', '56789012', 'Avenida Paulista', 500, 'São Paulo', 'SP', '1133338888', 'contato@biofarm.com'),
(6, 'UrbanGreen', '67890123000106', '67890123', 'Rua 7 de Setembro', 600, 'Porto Alegre', 'RS', '5133339999', 'contato@urbangreen.com'),
(7, 'NatureLab', '78901234000107', '78901234', 'Avenida Central', 700, 'Brasília', 'DF', '6133331010', 'contato@naturelab.com'),
(8, 'AgroFuture', '89012345000108', '89012345', 'Rua das Laranjeiras', 800, 'Fortaleza', 'CE', '8533332020', 'contato@agrofuture.com'),
(9, 'GrowSpace', '90123456000109', '90123456', 'Avenida Independência', 900, 'Recife', 'PE', '8133333030', 'contato@growspace.com'),
(10, 'EcoLife', '01234567000110', '01234567', 'Rua dos Pinheiros', 1000, 'Salvador', 'BA', '7133334040', 'contato@ecolife.com'),
(11, 'AgroPower', '12345678000111', '45612378', 'Rua Verde', 1100, 'Campinas', 'SP', '1133322233', 'agropower@empresa.com'),
(12, 'FarmLine', '23456789000112', '78945612', 'Avenida Boa Vista', 1200, 'Niterói', 'RJ', '2133311221', 'farmline@empresa.com'),
(13, 'Planta Viva', '34567890000113', '12378945', 'Rua Primavera', 1300, 'Florianópolis', 'SC', '4833334455', 'plantaviva@empresa.com'),
(14, 'BioVida', '45678901000114', '98765432', 'Rua Central', 1400, 'Goiânia', 'GO', '6233322112', 'biovida@empresa.com'),
(15, 'VerdeLife', '56789012000115', '65432198', 'Alameda Vista Alegre', 1500, 'João Pessoa', 'PB', '8333322233', 'verdelife@empresa.com'),
(16, 'EstufaTech', '67890123000116', '56478912', 'Rua Horizonte', 1600, 'Manaus', 'AM', '9233322111', 'estufatech@empresa.com'),
(17, 'Horta Moderna', '78901234000117', '87412356', 'Avenida Verdejante', 1700, 'Belém', 'PA', '9133322223', 'hortamoderna@empresa.com'),
(18, 'Cultivo Fácil', '89012345000118', '25896314', 'Rua Sol Nascente', 1800, 'Aracaju', 'SE', '7933322114', 'cultivofacil@empresa.com'),
(19, 'AgroSmart', '90123456000119', '98745123', 'Avenida do Progresso', 1900, 'Maceió', 'AL', '8233321111', 'agrosmart@empresa.com'),
(20, 'Terra Nova', '01234567000120', '13245678', 'Rua da Esperança', 2000, 'Natal', 'RN', '8433322211', 'terranova@empresa.com'),
(21, 'Cultivar', '12345678000121', '45612398', 'Rua Raízes', 2100, 'São Luís', 'MA', '9833321100', 'cultivar@empresa.com'),
(22, 'Horta Pronta', '23456789000122', '78912365', 'Avenida Girassol', 2200, 'Vitória', 'ES', '2733321001', 'hortapronta@empresa.com'),
(23, 'EcoHortas', '34567890000123', '96325814', 'Rua do Campo', 2300, 'Teresina', 'PI', '8633322212', 'ecohortas@empresa.com'),
(24, 'PlantPlus', '45678901000124', '74125896', 'Alameda das Árvores', 2400, 'Campo Grande', 'MS', '6733321234', 'plantplus@empresa.com'),
(25, 'FloraTech', '56789012000125', '32165487', 'Rua dos Pássaros', 2500, 'Macapá', 'AP', '9633322213', 'floratech@empresa.com'),
(26, 'HortaZen', '67890123000126', '12365478', 'Avenida Natureza', 2600, 'Boa Vista', 'RR', '9533322215', 'hortazen@empresa.com'),
(27, 'Verde e Vida', '78901234000127', '78965412', 'Rua Harmonia', 2700, 'Palmas', 'TO', '6333321002', 'verdeevida@empresa.com'),
(28, 'NatureField', '89012345000128', '45698732', 'Rua da Alegria', 2800, 'Cuiabá', 'MT', '6533322233', 'naturefield@empresa.com'),
(29, 'Floresta Verde', '90123456000129', '36985214', 'Avenida Tropical', 2900, 'Porto Velho', 'RO', '6933321122', 'florestaverde@empresa.com'),
(30, 'EcoRoots', '01234567000130', '12345678', 'Rua do Futuro', 3000, 'Rio Branco', 'AC', '6833322116', 'ecoroots@empresa.com');

GO
INSERT INTO Estufas (Id, IdUsuario, IdEmpresa, Modelo, Descricao, Preco, PeriodoLocacao) VALUES
(1, 1, 1, 'Modelo A', 'Estufa compacta para pequenos cultivos.', 1500.00, 12),
(2, 2, 2, 'Modelo B', 'Estufa automatizada com controle de umidade.', 2500.00, 24),
(3, 3, 3, 'Modelo C', 'Estufa modular para grandes cultivos.', 5000.00, 36),
(4, 4, 4, 'Modelo D', 'Estufa portátil para hortas urbanas.', 1200.00, 6),
(5, 5, 5, 'Modelo E', 'Estufa com sistema de irrigação embutido.', 3000.00, 18),
(6, 6, 6, 'Modelo F', 'Estufa resistente a intempéries.', 3500.00, 24),
(7, 7, 7, 'Modelo G', 'Estufa sustentável com energia solar.', 4000.00, 30),
(8, 8, 8, 'Modelo H', 'Estufa para cultivo vertical.', 2000.00, 12),
(9, 9, 9, 'Modelo I', 'Estufa com controle de temperatura avançado.', 4500.00, 36),
(10, 10, 10, 'Modelo J', 'Estufa econômica para iniciantes.', 1000.00, 6),
(11, 1, 11, 'Modelo K', 'Estufa compacta com design inovador.', 1600.00, 12),
(12, 2, 12, 'Modelo L', 'Estufa automatizada com sensores.', 2600.00, 24),
(13, 3, 13, 'Modelo M', 'Estufa modular para hortas.', 5100.00, 36),
(14, 4, 14, 'Modelo N', 'Estufa portátil leve.', 1300.00, 6),
(15, 5, 15, 'Modelo O', 'Estufa avançada para cultivo intensivo.', 3200.00, 18),
(16, 6, 16, 'Modelo P', 'Estufa resistente a ventos fortes.', 3700.00, 24),
(17, 7, 17, 'Modelo Q', 'Estufa ecológica de grande porte.', 4200.00, 30),
(18, 8, 18, 'Modelo R', 'Estufa para cultivo de frutas.', 2100.00, 12),
(19, 9, 19, 'Modelo S', 'Estufa controlada remotamente.', 4700.00, 36),
(20, 10, 20, 'Modelo T', 'Estufa para cultivo orgânico.', 1100.00, 6),
(21, 11, 21, 'Modelo U', 'Estufa compacta para iniciantes.', 1700.00, 12),
(22, 12, 22, 'Modelo V', 'Estufa para ambiente árido.', 2700.00, 24),
(23, 13, 23, 'Modelo W', 'Estufa com irrigação automatizada.', 5200.00, 36),
(24, 14, 24, 'Modelo X', 'Estufa portátil com montagem fácil.', 1400.00, 6),
(25, 15, 25, 'Modelo Y', 'Estufa avançada com iluminação LED.', 3300.00, 18),
(26, 16, 26, 'Modelo Z', 'Estufa resistente a chuvas fortes.', 3800.00, 24),
(27, 17, 27, 'Modelo AA', 'Estufa sustentável para grandes áreas.', 4300.00, 30),
(28, 18, 28, 'Modelo AB', 'Estufa para cultivo de vegetais.', 2200.00, 12),
(29, 19, 29, 'Modelo AC', 'Estufa inteligente com IoT.', 4800.00, 36),
(30, 20, 30, 'Modelo AD', 'Estufa econômica e prática.', 1200.00, 6);
