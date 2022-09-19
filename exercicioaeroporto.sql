USE SENAC;
create table aeroporto
(CODA char(3) not null,
NOMEA varchar(20) not null, 
CIDADE varchar(50) not null, 
PAIS char(2) not null,
constraint PK_AEROPORTO primary key(CODA));
insert into aeroporto values ('poa','salgado filho','porto alegre','BR');
insert into aeroporto values ('gru','guarulhos','sao paulo','BR');
insert into aeroporto values ('gal','galeao','rio de janeiro','BR');
insert into aeroporto values ('rom','fiumicino','roma','IT');
insert into aeroporto values ('stu','int de stuttgart','stutgart','AL');
insert into aeroporto values ('gau','charles de gaulle','paris','FR');
insert into aeroporto values ('mun','int de munique','munique','AL');
create table voo
(CODV char(5) not null, 
ORIGEM char(3) not null, 
DEST char(3) not null,
HORA int not null,
constraint PK_VOO primary key(CODV),
constraint FK_AER_VOOORIG foreign key (ORIGEM) references aeroporto (CODA),
constraint FK_AER_VOODEST foreign key (DEST) references aeroporto (CODA));
insert into voo values ('RG230','gru','poa','7');
insert into voo values ('RG330','gru','rom','11');
insert into voo values ('RG430','poa','gru','14');
insert into voo values ('RG530','gru','gau','17');
insert into voo values ('RG531','gau','gru','11');
insert into voo values ('VS100','gru','rom','14');
insert into voo values ('VS150','rom','gru','7');
insert into voo values ('LF200','gru','stu','8');
insert into voo values ('LF210','stu','mun','17');
insert into voo values ('KL400','gal','stu','14');
create table piloto
(CODP char(3) not null,
NOMEP varchar(10) not null,
SALARIO int not null, 
GRATIFICACOES int not null, 
TEMPO int not null, 
PAIS char(2) not null,
COMPANHIA varchar(10) not null,
constraint PK_PILOTO primary key(CODP));
insert into piloto values ('p11','joao', 3000, 200, 5,'BR','tam');
insert into piloto values ('p13','pedro', 2000, 100, 5,'BR','tam');
insert into piloto values ('p12','paulo', 3000, 200, 3,'BR','tam');
insert into piloto values ('p21','antonio', 1500, 300, 7,'BR','gol');
insert into piloto values ('p22','carlos', 5000, 200, 10,'BR','gol');
insert into piloto values ('p31','hanz', 5000, 1000, 6,'AL','lufthansa');
insert into piloto values ('p41','roel', 5000, 2000, 5,'NL','klm');
create table escala
(CODV char(5) not null, 
DATA date not null,
CODP char(3),
AVIAO varchar(10) not null,
constraint PK_ESCALA primary key(CODV, DATA),
constraint FK_PILOTO_ESCALA foreign key (CODP) references piloto (CODP),
constraint FK_VOO_ESCALA foreign key (CODV) references voo (CODV));
insert into escala values('RG230','2014-05-01','p11','777');
insert into escala values('RG230','2014-06-01','p11','777');
insert into escala values('VS100','2014-05-01','p21','A-320');
insert into escala values('LF200','2014-05-01','p31','777');
insert into escala values('RG330','2014-06-01','p12','777');
insert into escala values('RG330','2014-07-01','p12','A-320');
insert into escala values('RG530','2014-05-01','p12','A-320');
insert into escala values('LF200','2014-06-01','p31','A-320');
insert into escala values('KL400','2014-05-01','p41','A-320');
insert into escala values('LF210','2014-05-01','p31','A-320');
insert into escala values('VS150','2014-06-01','p21','A-320');

-- 1. Realize as seguintes consultas básicas: DICA -> USEM JOINS 
-- a. Selecione o nome da cidade e país de destino do vôo RG230.
-- b. Selecione o código de todos os vôos, nome dos pilotos 
-- escalados para os mesmos, e respectivos tipo de avião e companhia.
-- c. Selecione o código de todos os vôos para Alemanha ou Itália, com as 
-- respectivas datas e horas de saída.
-- d. Selecione o menor, o maior e a média dos salários dos
-- pilotos brasileiros (uma única consulta)

-- 2. Realize as seguintes consultas com agrupamento: DICA -> GROUP BY + HAVING
-- a. Selecione as companhias que pagam como salário mais 
-- alto a seus pilotos menos que R$2.000.
-- b. Selecione as companhias que só usam um tipo de avião.

-- 3. Realize as seguintes consultas com sub-consultas: DICA -> SUBSELECT
-- a. O nome dos pilotos que trabalham para companhias que empregam pelo 
-- menos dois pilotos.
-- b. O nome dos pilotos que ganham menos que a média salarial.

-- 1) a)
SELECT dest, cidade, pais
FROM aeroporto INNER JOIN voo ON voo.dest = aeroporto.coda 
WHERE voo.codv = 'RG230';

-- b)
SELECT codv, nomep, companhia, aviao
FROM escala INNER JOIN piloto ON 
escala.codp = piloto.codp;

-- c)
SELECT v.codv, data, hora
FROM voo v INNER JOIN escala e ON v.codv = e.codv
INNER JOIN aeroporto a ON v.dest = a.coda
WHERE pais = 'IT' OR pais = 'AL';

-- d)
SELECT min(salario), max(salario), avg(salario)
FROM piloto 
WHERE pais = 'BR'; 

-- 2) a)
SELECT companhia FROM piloto
GROUP BY companhia
HAVING max(salario) < 2000;

-- Usar o HAVING só em caso de GROUP BY

-- b)
SELECT companhia
FROM piloto p INNER JOIN escala e ON p.codp = e.codp
GROUP BY companhia
HAVING COUNT(DISTINCT aviao) = 1;

-- 3)a)
SELECT nomep FROM piloto 
WHERE companhia in 
(SELECT p.companhia FROM piloto p GROUP BY p.companhia HAVING COUNT(p.codp) > 1);

-- b)
SELECT nomep FROM piloto
WHERE salario < (SELECT AVG (p.salario) FROM piloto p);
