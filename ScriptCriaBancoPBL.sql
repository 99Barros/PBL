--> TABLES
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PBL')
BEGIN
    CREATE DATABASE PBL;
END
GO
USE PBL;
GO

CREATE TABLE Usuarios (
    Id INT PRIMARY KEY IDENTITY(1,1),
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
    Id INT PRIMARY KEY IDENTITY(1,1),
    NomeEmpresa NVARCHAR(150) NOT NULL,
    CNPJ NVARCHAR(20) NOT NULL UNIQUE, 
    Endereco NVARCHAR(255) NOT NULL,
    Telefone NVARCHAR(20),
    Email NVARCHAR(100),
    DataCadastro DATETIME NOT NULL DEFAULT GETDATE()
);
GO
CREATE TABLE Estufas (
    id INT PRIMARY KEY IDENTITY(1,1),
	IdUsuario INT NOT NULL,
    IdEmpresa INT NOT NULL,    
    Modelo NVARCHAR(50) NOT NULL,    
    Descricao NVARCHAR(255) NULL,
	Preco money ,
	PeriodoLocacao INT NOT NULL CHECK (PeriodoLocacao > 0),
    DataCadastro DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (IdEmpresa) REFERENCES Empresas(IdEmpresa) ON DELETE CASCADE,
	FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario) ON DELETE CASCADE
);

--> PROCEDURES GENERICAS

create procedure spDelete
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

create procedure spConsulta
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

create procedure spListagem
(
 @tabela varchar(max),
 @ordem varchar(max))
as
begin
 exec('select * from ' + @tabela +
 ' order by ' + @ordem)
end
GO

create procedure spProximoId
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
    @id int,
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
    INSERT INTO Estufas
    (id,IdUsuario, IdEmpresa, Modelo, Descricao, Preco, PeriodoLocacao, DataCadastro)
    VALUES
    (@id, @IdUsuario, @IdEmpresa, @Modelo, @Descricao, @Preco, @PeriodoLocacao, @DataCadastro)
END
GO

CREATE PROCEDURE spUpdate_Estufas
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
CREATE PROCEDURE spInsert_Usuarios
(
    @Id int,
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
    -- Se @DataRegistro não for fornecido, usará o valor padrão da coluna
    IF @DataRegistro IS NULL
        SET @DataRegistro = GETDATE();

    INSERT INTO Usuarios
    (Id, Login, Senha, Nome, Email, DataNascimento, Telefone, DataRegistro)
    VALUES
    (@Id, @Login, @Senha, @Nome, @Email, @DataNascimento, @Telefone, @DataRegistro);
END
GO

CREATE PROCEDURE spUpdate_Usuarios
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

--> Empresas

CREATE PROCEDURE spInsert_Empresas
(
    @Id INT;
    @NomeEmpresa NVARCHAR(150),
    @CNPJ NVARCHAR(20),
    @Endereco NVARCHAR(255),
    @Telefone NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @DataCadastro DATETIME = NULL
)
AS
BEGIN
    -- Se @DataCadastro não for fornecido, usará o valor padrão da coluna
    IF @DataCadastro IS NULL
        SET @DataCadastro = GETDATE();

    INSERT INTO Empresas
    (Id, NomeEmpresa, CNPJ, Endereco, Telefone, Email, DataCadastro)
    VALUES
    (@Id, @NomeEmpresa, @CNPJ, @Endereco, @Telefone, @Email, @DataCadastro);
END
GO

CREATE PROCEDURE spUpdate_Empresas
(
    @Id INT,
    @NomeEmpresa NVARCHAR(150),
    @CNPJ NVARCHAR(20),
    @Endereco NVARCHAR(255),
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
        Endereco = @Endereco,
        Telefone = @Telefone,
        Email = @Email,
        DataCadastro = ISNULL(@DataCadastro, DataCadastro) -- Mantém o valor atual se não for passado um novo valor
    WHERE Id = @Id;
END
GO




