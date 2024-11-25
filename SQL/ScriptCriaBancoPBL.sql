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
        FROM Estufas
        LEFT JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        LEFT JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
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
        FROM Estufas
        LEFT JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        LEFT JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
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
        LEFT JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        LEFT JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
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
        LEFT JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        LEFT JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
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
        FROM Estufas
        LEFT JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        LEFT JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
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
        LEFT JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        LEFT JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
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
        LEFT JOIN Usuarios ON Usuarios.Id = Estufas.IdUsuario
        LEFT JOIN Empresas ON Empresas.Id = Estufas.IdEmpresa
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
