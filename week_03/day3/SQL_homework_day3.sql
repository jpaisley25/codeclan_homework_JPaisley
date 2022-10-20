-- MVP
-- Q1


SELECT 
    count(*)
FROM employees 
WHERE salary IS NULL 
    AND grade IS NULL;

-- MVP
-- Q2

SELECT 
    department,
    concat(first_name, ' ', last_name) AS full_name 
FROM employees
ORDER BY (department, last_name);

-- MVP
-- Q3

SELECT 
    *
FROM employees 
WHERE last_name ~ '^A'
ORDER BY salary DESC NULLS LAST 
LIMIT 10;

-- MVP
-- Q4

SELECT 
    department, 
    count(*) AS count
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;


-- MVP
-- Q5

SELECT 
    department,
    fte_hours,
    count(*) AS number_of_employees
FROM employees
GROUP BY (department, fte_hours)
ORDER BY fte_hours ASC NULLS LAST;

-- MVP
-- Q6

SELECT
    pension_enrol,
    count(*) AS number_of_employees
FROM employees
GROUP BY pension_enrol;

-- MVP
-- Q7

SELECT 
    *
FROM employees 
WHERE department = 'Accounting' AND 
      pension_enrol IS FALSE 
ORDER BY salary DESC NULLS LAST 
LIMIT 1;


-- MVP
-- Q8

SELECT 
    country,
    count(*),
    avg(salary) AS avg_salary
FROM employees
GROUP BY country
HAVING count(*) > 30
ORDER BY avg_salary DESC NULLs LAST; 


-- MVP
-- Q9

SELECT 
    first_name,
    last_name,
    fte_hours,
    salary, 
    fte_hours * salary AS effective_yearly_salary
FROM employees
WHERE fte_hours * salary > 30000;

-- MVP
-- Q10

SELECT 
    *
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
WHERE t."name" = 'Data Team 1' OR 
      t."name" = 'Data Team 2';

-- MVP
-- Q11
  
  SELECT
    employees.first_name,
    employees.last_name 
  FROM employees 
  LEFT JOIN pay_details 
  ON employees.pay_detail_id = pay_details.id 
  WHERE pay_details.local_tax_code IS NULL;

-- MVP
-- Q12
  
SELECT
   e.first_name, 
   e.last_name,
   (48 * 35 * cast(charge_cost AS int) - salary) * fte_hours AS expected_profit
FROM employees  AS e
LEFT JOIN teams AS t
ON e.team_id  = t.id;


-- MVP
-- Q13

SELECT 
    first_name,
    last_name,
    salary 
FROM employees 
WHERE country = 'Japan' AND 
      fte_hours  = (SELECT  
                    fte_hours 
                FROM 
                    (SELECT
                        fte_hours,
                        count(*) AS n
                    FROM employees 
                    GROUP BY fte_hours
                    HAVING count(*) = (SELECT 
                                min(count) AS min
                            FROM(
                                SELECT
                                    count(*) AS count
                                FROM employees 
                                GROUP BY fte_hours
                                ) AS temp ) 
                      ) AS temp
                )
ORDER BY salary ASC NULLS LAST 
LIMIT 1;

-- MVP
-- Q14

SELECT 
    department,
    count(department) 
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING count(department) > 1
ORDER BY count DESC NULLS LAST, 
         department; 

-- MVP
-- Q15
     
     
SELECT
    first_name, 
    count(*)
FROM employees 
GROUP BY first_name 
HAVING count(*) > 1 AND 
       first_name IS NOT NULL
ORDER BY count DESC NULLS LAST, 
         first_name ; 

-- MVP
-- Q16
     

SELECT 
t1.department,
cast(t1.grade_1 AS real) / cast(t2.total AS real) AS proportion_grade_1
FROM 
(SELECT 
    department,
    grade,
    count(*) AS grade_1
FROM employees AS e
WHERE grade = 1
GROUP BY department, grade) AS t1
LEFT JOIN 
(SELECT
    department ,
    count(*) AS total
FROM employees AS eb
GROUP BY department) AS t2
ON t1.department = t2.department
ORDER by proportion_grade_1


-- Extension
-- Q1


WITH largest_dep(department) AS (
                SELECT  
                    department  
                FROM 
                    (SELECT
                        department ,
                        count(*) AS n
                    FROM employees 
                    GROUP BY department 
                    HAVING count(*) = (SELECT 
                                max(count) AS max
                            FROM(
                                SELECT
                                    count(*) AS count
                                FROM employees 
                                GROUP BY department 
                                ) AS temp ) 
                      ) AS temp
                ),
avg_salary_dep AS (
    SELECT
        avg(salary) AS avg_salary  
    FROM employees AS e INNER JOIN largest_dep
    ON e.department = largest_dep.department 
    WHERE e.department  = largest_dep.department),
avg_fte_hours_dep AS (
    SELECT
        avg(fte_hours) AS avg_fte_hours_dep  
    FROM employees AS e INNER JOIN largest_dep
    ON e.department = largest_dep.department 
    WHERE e.department  = largest_dep.department)
SELECT 
    id,
    first_name ,
    last_name ,
    e.department,
    salary,
    fte_hours,
    salary / (SELECT * FROM avg_salary_dep) AS salary_ratio,
    fte_hours / (SELECT * FROM avg_fte_hours_dep) AS fte_hours_ratio
FROM employees AS e INNER JOIN largest_dep
ON e.department = largest_dep.department 
WHERE e.department  = largest_dep.department;

-- Extension
-- Q2

SELECT
    COALESCE (CAST(pension_enrol AS varchar), 'unknown') as pension_enrol,
    count(*) AS number_of_employees
FROM employees
GROUP BY pension_enrol;

-- Extension
-- Q3

SELECT 
    e.first_name,
    e.last_name,
    e.email,
    e.start_date
FROM employees AS e
INNER JOIN employees_committees AS e_c 
ON e.id = e_c.employee_id 
INNER JOIN committees AS c 
ON e_c.committee_id = c.id 
WHERE c."name" ='Equality and Diversity'
ORDER BY start_date ASC NULLS LAST;


-- Extension
-- Q4

WITH salary_classes(
                    id,
                    salary,
                    salary_class) AS ( 
    SELECT 
    e.id,
    e.salary,
    CASE 
        WHEN salary < 40000 THEN 'low'
        WHEN salary >= 40000 THEN 'high'
        ELSE 'none' END AS salary_class
FROM employees AS e
INNER JOIN employees_committees AS e_c 
ON e.id = e_c.employee_id 
)
SELECT
    salary_class,
    count(DISTINCT(id))
FROM salary_classes 
GROUP BY salary_classes.salary_class;





