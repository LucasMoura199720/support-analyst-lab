-- ============================================================
--  SUPPORT ANALYST LAB — Dia 1
--  Lucas Araújo da Costa Moura
--  Base de dados: CRM/HelpDesk simulado (estilo Creatio)
--
--  Como usar:
--    1. Instalar DB Browser for SQLite (grátis): https://sqlitebrowser.org
--    2. File > New Database > guardar como "support.db"
--    3. File > Import > Database from SQL file > selecionar este ficheiro
--    4. Executar cada query individualmente na aba "Execute SQL"
-- ============================================================


-- ============================================================
--  PARTE 1 — SCHEMA (estrutura das tabelas)
-- ============================================================

-- Clientes da plataforma Creatio
CREATE TABLE IF NOT EXISTS customers (
    id          INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    company     TEXT,
    plan        TEXT CHECK(plan IN ('Free','Pro','Enterprise')),
    created_at  TEXT DEFAULT (date('now'))
);

-- Agentes de suporte
CREATE TABLE IF NOT EXISTS agents (
    id          INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    team        TEXT CHECK(team IN ('Tier1','Tier2','Cloud','Database')),
    active      INTEGER DEFAULT 1  -- 1=activo, 0=inactivo
);

-- Produtos da plataforma
CREATE TABLE IF NOT EXISTS products (
    id          INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    version     TEXT,
    category    TEXT CHECK(category IN ('CRM','Workflow','Integration','Cloud','Mobile'))
);

-- Tickets de suporte (core da base de dados)
CREATE TABLE IF NOT EXISTS tickets (
    id              INTEGER PRIMARY KEY,
    subject         TEXT NOT NULL,
    description     TEXT,
    status          TEXT CHECK(status IN ('Open','In Progress','Pending Customer','Resolved','Closed')),
    priority        TEXT CHECK(priority IN ('Low','Medium','High','Critical')),
    customer_id     INTEGER REFERENCES customers(id),
    agent_id        INTEGER REFERENCES agents(id),   -- NULL = por atribuir
    product_id      INTEGER REFERENCES products(id),
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT,
    resolved_at     TEXT,   -- NULL = ainda não resolvido
    escalated       INTEGER DEFAULT 0  -- 1 = foi escalado para Tier2/Dev
);

-- Actividades por ticket (notas, chamadas, emails, resoluções)
CREATE TABLE IF NOT EXISTS activities (
    id          INTEGER PRIMARY KEY,
    ticket_id   INTEGER REFERENCES tickets(id),
    agent_id    INTEGER REFERENCES agents(id),
    type        TEXT CHECK(type IN ('Note','Email','Call','Escalation','Resolution')),
    content     TEXT,
    created_at  TEXT DEFAULT (datetime('now'))
);


-- ============================================================
--  PARTE 2 — DADOS DE EXEMPLO (15 tickets, 8 clientes, etc.)
-- ============================================================

INSERT INTO customers VALUES
(1,'Empresa Alpha Lda','admin@alpha.pt','Alpha Lda','Enterprise','2024-01-10'),
(2,'Beta Solutions','support@beta.pt','Beta Solutions','Pro','2024-02-15'),
(3,'Carlos Ferreira','carlos@mail.pt',NULL,'Free','2024-03-01'),
(4,'Gamma Corp','it@gamma.com','Gamma Corp','Enterprise','2024-01-20'),
(5,'Delta Tech','delta@tech.io','Delta Tech','Pro','2024-04-05'),
(6,'Maria Santos','maria@santos.pt',NULL,'Free','2024-05-10'),
(7,'Omega Systems','ops@omega.eu','Omega Systems','Enterprise','2023-12-01'),
(8,'Pedro Costa','pedro@costa.pt',NULL,'Pro','2024-03-20');

INSERT INTO agents VALUES
(1,'Ana Silva','ana@creatio.com','Tier2',1),
(2,'Bruno Matos','bruno@creatio.com','Tier1',1),
(3,'Carla Neves','carla@creatio.com','Database',1),
(4,'David Rocha','david@creatio.com','Cloud',1),
(5,'Eva Lopes','eva@creatio.com','Tier2',1),
(6,'Fernando Dias','fernando@creatio.com','Tier1',0);  -- inactivo

INSERT INTO products VALUES
(1,'Creatio CRM','8.1','CRM'),
(2,'Creatio Studio','8.0','Workflow'),
(3,'Creatio Integration Hub','3.2','Integration'),
(4,'Creatio Cloud','2.5','Cloud'),
(5,'Creatio Mobile','1.8','Mobile');

INSERT INTO tickets VALUES
(1,'Login error after SSO update','Users cannot login after SSO configuration change','Resolved','High',1,1,1,'2024-05-01 09:00','2024-05-01 16:00','2024-05-01 16:00',0),
(2,'Workflow not triggering on record save','Business process rule silent failure','In Progress','Critical',4,3,2,'2024-05-02 10:00','2024-05-05 11:00',NULL,1),
(3,'Email integration stopped sending','SMTP connector returns 550 error','Pending Customer','High',2,1,3,'2024-05-03 08:30','2024-05-04 09:00',NULL,0),
(4,'Mobile app crashes on iOS 17','Crash on opening Contacts module','Open','Medium',6,2,5,'2024-05-10 14:00',NULL,NULL,0),
(5,'Report export generates empty file','CSV export from Opportunity view is empty','Resolved','Medium',3,5,1,'2024-04-28 11:00','2024-04-29 10:00','2024-04-29 10:00',0),
(6,'Cloud deployment failing','Azure provisioning returns 403 Forbidden','In Progress','Critical',7,4,4,'2024-05-06 07:00','2024-05-07 08:00',NULL,1),
(7,'Slow query on Accounts grid','Page takes 45s to load with 50k records','Open','High',1,3,1,'2024-05-08 15:00',NULL,NULL,0),
(8,'Cannot assign role to new user','Permission matrix not saving','Resolved','Low',5,2,1,'2024-05-01 13:00','2024-05-02 09:00','2024-05-02 09:00',0),
(9,'API rate limit exceeded','Integration returns 429 after 100 calls/min','Pending Customer','High',8,1,3,'2024-05-09 10:00','2024-05-10 10:00',NULL,0),
(10,'Data sync between CRM and ERP fails','Nightly sync job stuck at 30%','In Progress','Critical',4,3,3,'2024-05-04 06:00','2024-05-07 08:00',NULL,1),
(11,'Custom field not visible on mobile','Field added in Studio not syncing to mobile','Open','Low',2,2,5,'2024-05-11 09:00',NULL,NULL,0),
(12,'Database backup job failed','Scheduled backup returned exit code 1','Open','High',7,4,4,'2024-05-11 03:00',NULL,NULL,0),
(13,'Duplicate contacts after import','CSV import created 2x records','Resolved','Medium',1,5,1,'2024-05-05 11:00','2024-05-06 09:00','2024-05-06 09:00',0),
(14,'SSO token expiry too short','Session expires after 5 min','Open','Low',5,NULL,1,'2024-05-12 10:00',NULL,NULL,0),
(15,'Webhook payload malformed','JSON response missing required fields','In Progress','High',2,1,3,'2024-05-07 14:00','2024-05-08 09:00',NULL,0);

INSERT INTO activities VALUES
(1,1,1,'Email','Requested SSO config details from customer','2024-05-01 09:30'),
(2,1,1,'Call','Confirmed settings — identified wrong entity ID in IdP metadata','2024-05-01 11:00'),
(3,1,1,'Resolution','Fixed IdP metadata URL. Issue resolved and confirmed by customer.','2024-05-01 16:00'),
(4,2,3,'Escalation','Escalated to Tier2 — business process logic bug confirmed in sandbox','2024-05-02 14:00'),
(5,2,3,'Note','Reproduced in sandbox v8.0.3. Submitting detailed bug report to Dev team.','2024-05-05 11:00'),
(6,3,1,'Email','Asked customer to verify firewall rules on outbound SMTP relay port 587','2024-05-04 09:00'),
(7,6,4,'Note','403 likely caused by missing RBAC role on Azure subscription','2024-05-06 10:00'),
(8,6,4,'Call','Customer confirmed missing Contributor role on resource group — guiding remediation','2024-05-07 08:00'),
(9,9,1,'Email','Asked customer to implement request queuing with exponential backoff on their side','2024-05-10 10:00'),
(10,10,3,'Note','ETL job timing out at DB write step — investigating missing indexes on target table','2024-05-07 09:00');


-- ============================================================
--  PARTE 3 — AS 10 QUERIES (com explicação de cada uma)
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1 — Fila de trabalho: tickets abertos por prioridade
-- Contexto: primeira coisa que um agente vê ao iniciar o turno.
-- Conceitos: JOIN, WHERE com IN, ORDER BY com CASE (ordenação personalizada)
-- ------------------------------------------------------------

SELECT
    t.id,
    t.subject,
    t.status,
    t.priority,
    c.name   AS customer,
    c.plan   AS customer_plan
FROM tickets t
JOIN customers c ON t.customer_id = c.id
WHERE t.status IN ('Open', 'In Progress')
ORDER BY
    CASE t.priority
        WHEN 'Critical' THEN 1
        WHEN 'High'     THEN 2
        WHEN 'Medium'   THEN 3
        ELSE 4
    END,
    t.created_at ASC;


-- ------------------------------------------------------------
-- QUERY 2 — Carga de trabalho por agente
-- Contexto: o team lead usa esta query para distribuir tickets.
-- Conceitos: LEFT JOIN, GROUP BY, SUM com CASE (contagem condicional),
--            COUNT, WHERE em tabela principal (só agentes activos)
-- ------------------------------------------------------------

SELECT
    a.name                AS agent,
    a.team,
    COUNT(t.id)           AS total_tickets,
    SUM(CASE WHEN t.status IN ('Open','In Progress') THEN 1 ELSE 0 END) AS open_tickets,
    SUM(CASE WHEN t.status IN ('Resolved','Closed')  THEN 1 ELSE 0 END) AS resolved_tickets
FROM agents a
LEFT JOIN tickets t ON t.agent_id = a.id
WHERE a.active = 1
GROUP BY a.id
ORDER BY open_tickets DESC;


-- ------------------------------------------------------------
-- QUERY 3 — Top 5 tickets abertos há mais tempo (SLA alert)
-- Contexto: identifica tickets em risco de violar o SLA.
-- Conceitos: julianday() para calcular diferença de datas,
--            ROUND, ORDER BY, LIMIT, IS NULL
-- ------------------------------------------------------------

SELECT
    t.id,
    t.subject,
    c.name   AS customer,
    c.plan,
    t.priority,
    ROUND((julianday('now') - julianday(t.created_at)), 1) AS days_open
FROM tickets t
JOIN customers c ON t.customer_id = c.id
WHERE t.status NOT IN ('Resolved', 'Closed')
  AND t.resolved_at IS NULL
ORDER BY days_open DESC
LIMIT 5;


-- ------------------------------------------------------------
-- QUERY 4 — Tickets por produto (qual módulo tem mais problemas)
-- Contexto: relatório semanal para a equipa de produto.
-- Conceitos: LEFT JOIN (inclui produtos sem tickets), GROUP BY,
--            SUM condicional, múltiplas métricas numa só query
-- ------------------------------------------------------------

SELECT
    p.name       AS product,
    p.version,
    COUNT(t.id)  AS total_tickets,
    SUM(CASE WHEN t.status IN ('Open','In Progress','Pending Customer') THEN 1 ELSE 0 END) AS open_tickets,
    SUM(CASE WHEN t.priority IN ('Critical','High') THEN 1 ELSE 0 END) AS high_priority_tickets
FROM products p
LEFT JOIN tickets t ON t.product_id = p.id
GROUP BY p.id
ORDER BY total_tickets DESC;


-- ------------------------------------------------------------
-- QUERY 5 — Todos os tickets escalados
-- Contexto: manager precisa de saber o que está escalado e porquê.
-- Conceitos: JOIN múltiplo (3 tabelas), WHERE simples, alias
-- ------------------------------------------------------------

SELECT
    t.id,
    t.subject,
    t.status,
    t.priority,
    c.name   AS customer,
    c.plan,
    a.name   AS assigned_agent,
    t.created_at
FROM tickets t
JOIN customers c ON t.customer_id = c.id
LEFT JOIN agents a ON t.agent_id = a.id
WHERE t.escalated = 1
ORDER BY t.created_at ASC;


-- ------------------------------------------------------------
-- QUERY 6 — Tempo médio de resolução por prioridade
-- Contexto: métrica de performance do suporte (Mean Time to Resolve).
-- Conceitos: AVG, ROUND, julianday, WHERE com NOT NULL,
--            GROUP BY em coluna calculada
-- ------------------------------------------------------------

SELECT
    t.priority,
    COUNT(t.id) AS tickets_resolved,
    ROUND(AVG((julianday(t.resolved_at) - julianday(t.created_at)) * 24), 1) AS avg_hours_to_resolve,
    ROUND(MIN((julianday(t.resolved_at) - julianday(t.created_at)) * 24), 1) AS min_hours,
    ROUND(MAX((julianday(t.resolved_at) - julianday(t.created_at)) * 24), 1) AS max_hours
FROM tickets t
WHERE t.resolved_at IS NOT NULL
GROUP BY t.priority
ORDER BY avg_hours_to_resolve ASC;


-- ------------------------------------------------------------
-- QUERY 7 — Tickets sem agente atribuído (por atribuir)
-- Contexto: ao iniciar o turno, identificar tickets "orphaned".
-- Conceitos: IS NULL como condição, JOIN, filtro de status
-- ------------------------------------------------------------

SELECT
    t.id,
    t.subject,
    t.priority,
    t.status,
    c.name   AS customer,
    c.plan,
    t.created_at
FROM tickets t
JOIN customers c ON t.customer_id = c.id
WHERE t.agent_id IS NULL
  AND t.status NOT IN ('Resolved', 'Closed')
ORDER BY
    CASE t.priority WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 ELSE 3 END;


-- ------------------------------------------------------------
-- QUERY 8 — Actividade dos agentes por tipo
-- Contexto: mostra o padrão de trabalho de cada agente
--           (mais emails? mais chamadas? mais notas internas?)
-- Conceitos: GROUP BY em múltiplas colunas, COUNT, ORDER BY múltiplo
-- ------------------------------------------------------------

SELECT
    a.name       AS agent,
    a.team,
    act.type     AS activity_type,
    COUNT(*)     AS count
FROM activities act
JOIN agents a ON act.agent_id = a.id
GROUP BY a.id, act.type
ORDER BY a.name, count DESC;


-- ------------------------------------------------------------
-- QUERY 9 — Clientes com mais escalações (health score)
-- Contexto: identifica clientes em risco de churna ou insatisfação.
-- Conceitos: GROUP BY com HAVING, múltiplos SUM condicionais,
--            ORDER BY em múltiplas colunas
-- ------------------------------------------------------------

SELECT
    c.name,
    c.plan,
    c.company,
    COUNT(t.id)  AS total_tickets,
    SUM(CASE WHEN t.status IN ('Open','In Progress','Pending Customer') THEN 1 ELSE 0 END) AS open_now,
    SUM(CASE WHEN t.escalated = 1 THEN 1 ELSE 0 END) AS escalations,
    SUM(CASE WHEN t.priority = 'Critical' THEN 1 ELSE 0 END) AS critical_tickets
FROM customers c
LEFT JOIN tickets t ON t.customer_id = c.id
GROUP BY c.id
HAVING total_tickets > 0
ORDER BY escalations DESC, critical_tickets DESC, total_tickets DESC;


-- ------------------------------------------------------------
-- QUERY 10 — Tickets "silenciosos" (sem actividade recente)
-- Contexto: a mais importante para suporte Tier 2 — detecta tickets
--           que estão parados sem resposta ao cliente.
-- Conceitos: LEFT JOIN com subquery implícita via MAX, HAVING,
--            julianday para calcular dias sem actividade, IS NULL
-- ------------------------------------------------------------

SELECT
    t.id,
    t.subject,
    t.status,
    t.priority,
    c.name                            AS customer,
    t.created_at,
    MAX(act.created_at)               AS last_activity,
    ROUND(
        julianday('now') - julianday(COALESCE(MAX(act.created_at), t.created_at))
    , 1)                              AS days_since_last_activity
FROM tickets t
JOIN customers c ON t.customer_id = c.id
LEFT JOIN activities act ON act.ticket_id = t.id
WHERE t.status NOT IN ('Resolved', 'Closed')
GROUP BY t.id
HAVING days_since_last_activity > 2
    OR last_activity IS NULL
ORDER BY days_since_last_activity DESC;


-- ============================================================
--  FIM DO FICHEIRO
--  Para a entrevista, pratica explicar em voz alta o que cada
--  query faz e porque seria útil num sistema de suporte real.
-- ============================================================
