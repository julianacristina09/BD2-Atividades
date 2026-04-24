#Liste todos os alunos cadastrados
SELECT *
FROM aluno;

#Mostre apenas o nome e o curso dos alunos
SELECT nome, curso
FROM aluno;

#Liste os alunos do curso de Computacao
SELECT *
FROM aluno
WHERE curso = 'Computacao';

#Liste os alunos que moram em Maringa.
SELECT *
FROM aluno
WHERE cidade = 'Maringa';

#Mostre os alunos ordenados pelo nome em ordem alfabética.
SELECT *
FROM aluno
ORDER BY nome ASC;

#Mostre os alunos ordenados pelo ano de ingresso, do mais antigo para o mais recente.
SELECT *
FROM aluno
ORDER BY ano_ingresso ASC;

#Liste os alunos que ingressaram a partir de 2022.
SELECT *
FROM aluno
WHERE ano_ingresso >= 2022;

#Liste os alunos cujo nome começa com a letra A.
SELECT *
FROM aluno
WHERE nome LIKE 'A%';

#Liste os alunos dos cursos Computacao ou Engenharia.
SELECT *
FROM aluno
WHERE curso IN ('Computacao', 'Engenharia');

#Liste as disciplinas com carga horária entre 60 e 80 horas.
SELECT *
FROM disciplina
WHERE carga_horaria BETWEEN 60 AND 80;

#Conte quantos alunos existem cadastrados.
SELECT COUNT(*) AS total_alunos
FROM aluno;

#Calcule a média das notas da tabela matricula.
SELECT AVG(nota) AS media_notas
FROM matricula;

#Mostre a maior nota registrada.
SELECT MAX(nota) AS maior_nota
FROM matricula;

#Mostre a menor nota registrada.
SELECT MIN(nota) AS menor_nota
FROM matricula;

#Calcule a soma das cargas horárias de todas as disciplinas.
SELECT SUM(carga_horaria) AS soma_carga_horaria
FROM disciplina;

#Mostre a quantidade de alunos por curso.
SELECT curso, COUNT(*) AS quantidade
FROM aluno
GROUP BY curso;

#Mostre a quantidade de alunos por cidade.
SELECT cidade, COUNT(*) AS quantidade
FROM aluno
GROUP BY cidade;

#Mostre a média das notas por situação da matrícula.
SELECT situacao, AVG(nota) AS media_notas
FROM matricula
GROUP BY situacao;

#Mostre quantas matrículas existem por semestre.
SELECT semestre, COUNT(*) AS quantidade
FROM matricula
GROUP BY semestre;

#Mostre os cursos que possuem mais de 1 aluno cadastrado.
SELECT curso, COUNT(*) AS quantidade
FROM aluno
GROUP BY curso
HAVING COUNT(*) > 1;

#Liste o nome dos alunos e a situação de suas matrículas.
SELECT aluno.nome, matricula.situacao
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id;

#Liste o nome dos alunos e o nome das disciplinas em que estão matriculados.
SELECT aluno.nome AS nome_aluno,
       disciplina.nome AS nome_disciplina
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
INNER JOIN disciplina
ON disciplina.id = matricula.disciplina_id;

#Liste o nome do aluno, o nome da disciplina e a nota.
SELECT aluno.nome AS nome_aluno,
       disciplina.nome AS nome_disciplina,
       matricula.nota
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
INNER JOIN disciplina
ON disciplina.id = matricula.disciplina_id;

#Liste apenas os alunos matriculados em disciplinas do departamento Computacao.
SELECT aluno.nome AS nome_aluno,
       disciplina.nome AS nome_disciplina,
       disciplina.departamento
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
INNER JOIN disciplina
ON disciplina.id = matricula.disciplina_id
WHERE disciplina.departamento = 'Computacao';

#Mostre o nome dos alunos que tiveram matrícula com situação Reprovado.
SELECT aluno.nome
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
WHERE matricula.situacao = 'Reprovado';

#Mostre o nome dos alunos de Computacao e as disciplinas que eles cursaram.
SELECT aluno.nome AS nome_aluno,
       disciplina.nome AS nome_disciplina
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
INNER JOIN disciplina
ON disciplina.id = matricula.disciplina_id
WHERE aluno.curso = 'Computacao';

#Mostre a média de notas por aluno.
SELECT aluno.nome,
       AVG(matricula.nota) AS media_notas
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
GROUP BY aluno.id, aluno.nome;

#Mostre a quantidade de disciplinas cursadas por cada aluno.
SELECT aluno.nome,
       COUNT(matricula.disciplina_id) AS quantidade_disciplinas
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
GROUP BY aluno.id, aluno.nome;

#Liste os alunos cuja média de notas foi maior que 8.
SELECT aluno.nome,
       AVG(matricula.nota) AS media_notas
FROM aluno
INNER JOIN matricula
ON aluno.id = matricula.aluno_id
GROUP BY aluno.id, aluno.nome
HAVING AVG(matricula.nota) > 8;

#Mostre o departamento e a quantidade de matrículas em disciplinas de cada departamento.
SELECT disciplina.departamento,
       COUNT(matricula.id) AS quantidade_matriculas
FROM disciplina
INNER JOIN matricula
ON disciplina.id = matricula.disciplina_id
GROUP BY disciplina.departamento;