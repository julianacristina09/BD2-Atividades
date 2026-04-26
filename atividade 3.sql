DROP TABLE IF EXISTS contas;

CREATE TABLE contas (
    id INT PRIMARY KEY,
    titular VARCHAR(100),
    saldo DECIMAL(10,2)
);

INSERT INTO contas (id, titular, saldo) VALUES
(1, 'Ana', 1000.00),
(2, 'Bruno', 500.00),
(3, 'Carlos', 300.00),
(4, 'Daniela', 800.00);

SELECT * FROM contas;

#Qual é o objetivo da tabela contas neste cenário prático?
#A tabela contas representa contas bancárias fictícias usadas para simular operações financeiras, é um ambiente de treino para aprender como bancos reais funcionam.

#Quais são os saldos iniciais de cada titular antes da execução das transações?
Ana      1000,00
Bruno     500,00
Carlos    300,00
Daniela   800,00

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 100
WHERE id = 2;

COMMIT;

SELECT * FROM contas;

#O que aconteceu com os saldos após o COMMIT?
#Ana transferiu 100 para Bruno, após o COMMIT as alterações foram confirmadas definitivamente no banco

#Por que as duas instruções UPDATE devem fazer parte da mesma transação?
#Porque fazem parte da mesma transferência. Se só executar o primeiro a Ana perde dinheiro mas o Bruno não vai receber gerando uma inconsistência

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 50
WHERE id = 2;

UPDATE contas
SET saldo = saldo + 50
WHERE id = 3;

ROLLBACK;

SELECT * FROM contas;

#Por que os valores não foram alterados ao final?
#Porque o ROLLBACK foi executado desfazendo tudo o que aconteceu dentro da transação

#Em quais situações reais o uso de ROLLBACK seria essencial?
#Existem várias situações em que o ROLLBACK seria essencial como por exemplo queda de energia, erro no sistema, saldo insuficiente, usuário cancelou operação, falha de rede, inconsistência detectada.

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 2000
WHERE id = 3;

SELECT * FROM contas WHERE id = 3;

ROLLBACK;

#Por que a transação foi desfeita neste caso?
#Porque ao consultar percebeu-se que o saldo seria negativo ou seja o resultado seria inválido, então o sistema cancelou com ROLLBACK.

#Qual problema de integridade poderia ocorrer se essa transação fosse confirmada?
#Saldo negativo indevido.

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 4;

UPDATE contas
SET saldo = saldo + 60
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 40
WHERE id = 2;

COMMIT;

SELECT * FROM contas;

#Qual conta foi debitada e quais contas foram creditadas?
#A conta da Daniela foi debitada e a conta da Ana e do Bruno foram creditadas.

#Por que esse conjunto de operações também deve ser tratado como uma única transação?
#Porque tudo faz parte de uma única operação financeira, se uma parte falhar, tudo deve ser cancelado.

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 150
WHERE id = 1;

SELECT * FROM contas WHERE id = 1;

SELECT * FROM contas WHERE id = 1;

#Qual era o objetivo de observar o valor da conta em outra sessão antes do COMMIT?
#Verificar se outra conexão consegue enxergar alteração antes do COMMIT.

#Como esse teste se relaciona com o conceito de isolamento?
#O conceito de isolamento significa que transações em andamento não devem atrapalhar outras, enquanto não houver COMMIT, normalmente outros usuários não veem a mudança definitiva.

START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 1;

START TRANSACTION;

UPDATE contas
SET saldo = saldo + 300
WHERE id = 1;

COMMIT;

#O que aconteceu com a segunda transação?
#A segunda transação ficou esperando, praticamente bloqueada.

#Por que ela precisou esperar?
#Porque a primeira sessão já estava alterando aquela mesma conta então o banco protegeu o dado.

#Qual a função do FOR UPDATE?
#Bloquear a linha selecionada para atualização, ninguém pode alterar nada até terminar a transação atual.

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 50
WHERE id = 1;

START TRANSACTION;

UPDATE contas
SET saldo = saldo + 70
WHERE id = 4;

#Por que nesse caso as transações tendem a não disputar o mesmo recurso?
#Porque são linhas diferentes e não disputam o mesmo registro.

#O que esse teste mostra sobre concorrência em linhas diferentes da tabela?
#Mostra que o banco permite concorrência quando não há conflito direto melhorando o desempenho.

DROP TABLE IF EXISTS movimentacoes;

CREATE TABLE movimentacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conta_origem INT,
    conta_destino INT,
    valor DECIMAL(10,2),
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

#Qual é a importância de registrar movimentações além de atualizar os saldos?
#A impotância de registrat movimentações é guardar histórico algo muito importante para auditoria e rastreamento.

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 120
WHERE id = 2;

UPDATE contas
SET saldo = saldo + 120
WHERE id = 3;

INSERT INTO movimentacoes (conta_origem, conta_destino, valor)
VALUES (2, 3, 120.00);

COMMIT;

SELECT * FROM contas;
SELECT * FROM movimentacoes;

#Por que o INSERT na tabela movimentacoes deve estar na mesma transação dos UPDATEs?
#Porque tudo é uma única transferência, o saldo e o histórico precisam acontecer juntos.

#O que poderia acontecer se o histórico fosse gravado, mas os saldos não fossem atualizados, ou vice-versa?
#Se histórico fosse gravado e os saldos não fosse atualizados, mostra transferência falsa. Se o saldo mudar e histórico não fosse gravado, dinheiro some sem registro. 

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 80
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 80
WHERE id = 4;

ROLLBACK;

SELECT * FROM contas;
SELECT * FROM movimentacoes;

#O que o ROLLBACK garantiu nesse cenário?
#O ROLLBACK Cancelou toda operação incompleta e nenhum saldo foi alterado indevidamente.

#Como esse teste demonstra a propriedade de atomicidade?
#A atomicidade foi demonstrada, pois a transação ocorreu como uma única operação: ou todas as alterações seriam concluídas, ou nenhuma seria mantida. Com o ROLLBACK, todas as mudanças foram desfeitas.

SELECT * FROM contas;
SELECT * FROM movimentacoes;

#Como verificar se o banco permaneceu consistente após todas as operações realizadas?
#Verificando se os valores fazem sentido, se os totais batem, se o histórico corresponde aos saldos.

#Por que a consistência do banco depende não apenas dos comandos SQL, mas também da forma como eles são agrupados em transações?
#Não basta comando correto, também é preciso agrupamento correto em transações senão metade executa e metade falha.

#Explique o que é uma transação em banco de dados.
#Uma transação em banco de dados é um conjunto de operações executadas como uma única unidade lógica. Essas operações precisam ser concluídas por completo para que os dados sejam mantidos. Caso ocorra algum erro, todas as alterações podem ser desfeitas, preservando a integridade do banco.

#Descreva a diferença entre COMMIT e ROLLBACK.
#O COMMIT é o comando utilizado para confirmar definitivamente as alterações realizadas em uma transação. Já o ROLLBACK serve para cancelar a transação e desfazer todas as mudanças feitas desde o início dela.

#Explique por que uma transferência bancária deve ser tratada como transação.
#Uma transferência bancária envolve pelo menos duas operações: debitar o valor de uma conta e creditar em outra. Essas etapas precisam acontecer juntas. Se apenas uma delas for executada, haverá inconsistência nos saldos.

#O que pode acontecer se duas transações alterarem o mesmo dado ao mesmo tempo sem controle de concorrência?
#Pode ocorrer conflito entre as operações, resultando em valores incorretos, perda de atualizações ou dados inconsistentes. Um exemplo é duas pessoas alterarem o mesmo saldo simultaneamente.

#Qual a relação entre transações e as propriedades ACID?
#As transações seguem as propriedades ACID, que garantem segurança e confiabilidade no processamento. Elas representam Atomicidade, Consistência, Isolamento e Durabilidade.

#Explique o significado da propriedade de atomicidade no contexto de uma operação bancária.
#A atomicidade significa que a operação será executada por completo ou não será executada. Em uma transferência bancária, o valor só pode sair de uma conta se também entrar na outra.

#Explique o que significa dizer que uma transação preserva a consistência do banco de dados.
#Significa que, após a transação, o banco continua obedecendo todas as regras definidas, mantendo os dados corretos, completos e sem contradições.

#Descreva o papel do isolamento em ambientes com múltiplos usuários acessando o mesmo banco.
#O isolamento garante que várias transações possam ocorrer ao mesmo tempo sem interferirem umas nas outras. Cada usuário executa sua operação sem visualizar alterações incompletas de outra transação.

#Explique a importância da durabilidade após a execução de um COMMIT.
#A durabilidade garante que, após o COMMIT, os dados confirmados permanecerão salvos, mesmo em casos de falha no sistema, queda de energia ou reinicialização.

#O que é controle de concorrência e por que ele é necessário?
#Controle de concorrência é o conjunto de mecanismos que organiza o acesso simultâneo aos dados. Ele é necessário para evitar conflitos, erros e inconsistências quando vários usuários utilizam o sistema ao mesmo tempo.

#Explique a função do lock em transações concorrentes.
#O lock é um bloqueio temporário aplicado aos dados para impedir que outra transação os altere ao mesmo tempo. Isso protege a integridade das informações.

#Descreva um exemplo prático em que o FOR UPDATE seja necessário.
#Um exemplo é a consulta de saldo antes de realizar um saque bancário. O FOR UPDATE bloqueia o registro da conta até o fim da transação, impedindo alterações simultâneas.

#O que é uma atualização perdida (lost update)?
#É quando duas transações alteram o mesmo dado ao mesmo tempo e a última gravação sobrescreve a anterior, fazendo com que uma atualização seja perdida.

#Explique por que nem toda leitura concorrente gera problema, mas algumas atualizações simultâneas sim.
#Leituras normalmente apenas consultam informações e não modificam dados. Já atualizações simultâneas podem alterar o mesmo registro, causando conflitos e resultados incorretos.

#Qual é a importância de registrar operações em uma tabela de histórico dentro da mesma transação?
#Isso garante que o histórico e os saldos fiquem sincronizados. Se a operação falhar, nenhuma alteração parcial será mantida.

#Em um sistema acadêmico, cite um exemplo de operação que deveria ser tratada como transação.
#A matrícula de um aluno em disciplina, pois envolve registrar a matrícula, atualizar vagas disponíveis e possivelmente gerar cobrança.

#Em um sistema de estoque, cite um exemplo de falha que poderia justificar o uso de ROLLBACK.
#Uma venda em que o sistema reduz o estoque, mas depois identifica que não há quantidade suficiente disponível. Nesse caso, a operação deve ser cancelada.

#Como o processamento de transações contribui para a confiabilidade de sistemas de informação?
#Ele garante operações seguras, evita perda de dados, corrige falhas e mantém a consistência das informações, aumentando a confiança no sistema.

#Considerando todos os experimentos realizados, explique de forma integrada como atomicidade, consistência, isolamento e durabilidade atuam em conjunto no processamento de transações.
#Essas quatro propriedades trabalham juntas para garantir segurança no banco de dados. A atomicidade assegura que tudo seja concluído ou cancelado. A consistência mantém os dados corretos. O isolamento evita conflitos entre usuários simultâneos. A durabilidade garante que, após o COMMIT, os dados permaneçam salvos. Juntas, tornam o sistema confiável e estável.
