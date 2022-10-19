
-- MVP
-- Q1a

SELECT 
    e.first_name,
    e.last_name,
    t."name" AS team_name
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id;

-- MVP
-- Q1b

SELECT 
    e.first_name,
    e.last_name,
    t."name" AS team_name
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
WHERE e.pension_enrol = TRUE;

-- MVP
-- Q1c

SELECT 
    e.first_name,
    e.last_name,
    t."name" AS team_name
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
WHERE cast(t.charge_cost AS int) > 80;


-- MVP
-- Q2a

SELECT 
    e.*,
    pd.local_account_no,
    pd.local_sort_code
FROM employees AS e
LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id; 


-- MVP
-- Q2b

SELECT 
    e.*,
    pd.local_account_no,
    pd.local_sort_code,
    t."name" AS team_name
FROM employees AS e
LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id 
LEFT JOIN teams AS t 
ON e.team_id = t.id;  


-- MVP
-- Q3a

SELECT 
    e.id AS employee_id,
    t."name" AS team_name
FROM employees AS e
left JOIN teams AS t 
ON e.team_id = t.id;


-- MVP
-- Q3b

SELECT 
    t."name" AS team_name,
    count(e.id) 
FROM employees AS e
left JOIN teams AS t 
ON e.team_id = t.id
GROUP BY team_name;


-- MVP
-- Q3c

SELECT 
    t."name" AS team_name,
    count(e.id) AS n
FROM employees AS e
left JOIN teams AS t 
ON e.team_id = t.id
GROUP BY team_name
ORDER BY n ASC NULLS LAST ;

-- MVP
-- Q4a

SELECT
    e.team_id,
    t."name" AS team_name,
    count(e.id) AS n
FROM employees AS e
left JOIN teams AS t 
ON e.team_id = t.id
GROUP BY (team_name, e.team_id)
ORDER BY n ASC NULLS LAST ;

-- MVP
-- Q4b

SELECT
    e.team_id,
    t."name" AS team_name,
    sum(cast(t.charge_cost AS int))  AS total_day_charge
FROM employees AS e
left JOIN teams AS t 
ON e.team_id = t.id
GROUP BY (team_name, e.team_id)
ORDER BY total_day_charge ASC NULLS LAST;

-- MVP
-- Q4c

SELECT
    e.team_id,
    t."name" AS team_name,
    sum(cast(t.charge_cost AS int))  AS total_day_charge
FROM employees AS e
left JOIN teams AS t 
ON e.team_id = t.id
GROUP BY (team_name, e.team_id)
HAVING sum(cast(t.charge_cost AS int)) > 5000
ORDER BY total_day_charge ASC NULLS LAST;

-- Extension Q5

SELECT 
    count(DISTINCT  e.id) 
FROM employees AS e 
inner JOIN employees_committees  AS e_c 
ON e.id = e_c.employee_id;

-- Extension Q6

SELECT 
    count(*) 
FROM employees AS e 
Left JOIN employees_committees  AS e_c 
ON e.id = e_c.employee_id
GROUP BY e_c.committee_id 
HAVING committee_id IS NULL; 

























