/* ===================== JOIN QUERIES ===================== */

/* 1. Name, salary and dept.id of employees in Sales department */
SELECT e.FNAME || ' ' || e.LNAME AS NAME, e.SALARY, e.DEPTID
FROM EMPLOYEErc e
JOIN DEPARTMENTrc d ON e.DEPTID = d.DEPTID
WHERE d.DEPTNAME = 'Sales';


/* 2. Employee names and their dependent info (OUTER JOIN) */
SELECT e.FNAME || ' ' || e.LNAME AS NAME,
       d.DEPENDENTID, d.RELATION, d.DEPDOB
FROM EMPLOYEErc e
LEFT OUTER JOIN DEPENDENTrc d
ON e.EMPLOYEEID = d.EMPLOYEEID;


/* 3. Employee fullname & salary with supervisor name & salary */
SELECT e.FNAME || ' ' || e.LNAME AS EMP_NAME,
       e.SALARY AS EMP_SALARY,
       s.FNAME || ' ' || s.LNAME AS SUP_NAME,
       s.SALARY AS SUP_SALARY
FROM EMPLOYEErc e
LEFT JOIN EMPLOYEErc s
ON e.SUPERVISOR = s.EMPLOYEEID;


/* 4. Fullname, salary and level based on salary */
SELECT e.FNAME || ' ' || e.LNAME AS NAME,
       e.SALARY,
       l.LEVELNO
FROM EMPLOYEErc e
JOIN EMPLOYEELEVELrc l
ON e.SALARY BETWEEN l.LOWSALARY AND l.HIGHSALARY;


/* 5. Employee name, supervisor name, dept name,
      position desc, qualification desc */
SELECT e.FNAME || ' ' || e.LNAME AS EMP_NAME,
       s.FNAME || ' ' || s.LNAME AS SUP_NAME,
       d.DEPTNAME,
       p.POSDESC,
       q.QUALDESC
FROM EMPLOYEErc e
LEFT JOIN EMPLOYEErc s ON e.SUPERVISOR = s.EMPLOYEEID
JOIN DEPARTMENTrc d ON e.DEPTID = d.DEPTID
JOIN POSITIONrc p ON e.POSITIONID = p.POSITIONID
JOIN QUALIFICATIONrc q ON e.QUALID = q.QUALID;


/* ===================== NESTED QUERIES ===================== */

/* 6. Jinku Shaw’s department name */
SELECT DEPTNAME
FROM DEPARTMENTrc
WHERE DEPTID = (
    SELECT DEPTID
    FROM EMPLOYEErc
    WHERE FNAME = 'Jinku' AND LNAME = 'Shaw'
);


/* 7. Supervisor name for employee number 433 */
SELECT FNAME || ' ' || LNAME AS SUPERVISOR_NAME
FROM EMPLOYEErc
WHERE EMPLOYEEID = (
    SELECT SUPERVISOR
    FROM EMPLOYEErc
    WHERE EMPLOYEEID = 433
);


/* 8. Employees in Sales department */
SELECT FNAME, LNAME
FROM EMPLOYEErc
WHERE DEPTID = (
    SELECT DEPTID
    FROM DEPARTMENTrc
    WHERE DEPTNAME = 'Sales'
);


/* 9. Employees NOT in John Smith’s department */
SELECT FNAME, LNAME, SALARY, DEPTID
FROM EMPLOYEErc
WHERE DEPTID <> (
    SELECT DEPTID
    FROM EMPLOYEErc
    WHERE FNAME = 'John' AND LNAME = 'Smith'
);


/* 10. Employees with salary > salary of Dev */
SELECT FNAME, LNAME, SALARY, DEPTID
FROM EMPLOYEErc
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEErc
    WHERE LNAME = 'Dev'
);


/* 11. Departments with more employees than dept 20 */
SELECT DEPTID
FROM EMPLOYEErc
GROUP BY DEPTID
HAVING COUNT(*) >
(
    SELECT COUNT(*)
    FROM EMPLOYEErc
    WHERE DEPTID = 20
);


/* 12. Employees with same qualification as Stanley Garner */
SELECT FNAME, LNAME
FROM EMPLOYEErc
WHERE QUALID = (
    SELECT QUALID
    FROM EMPLOYEErc
    WHERE FNAME = 'Stanley' AND LNAME = 'Garner'
);


/* 13. Increase salary by 3% for employees in Infosys */
UPDATE EMPLOYEErc
SET SALARY = SALARY * 1.03
WHERE DEPTID = (
    SELECT DEPTID
    FROM DEPARTMENTrc
    WHERE DEPTNAME = 'Infosys'
);


/* 14. Delete employees in Accounting department */
DELETE FROM EMPLOYEErc
WHERE DEPTID = (
    SELECT DEPTID
    FROM DEPARTMENTrc
    WHERE DEPTNAME = 'Accounting'
);


/* 15. Employees working as Manager */
SELECT FNAME, LNAME
FROM EMPLOYEErc
WHERE POSITIONID = (
    SELECT POSITIONID
    FROM POSITIONrc
    WHERE POSDESC = 'Manager'
);


/* 16. Not Managers & salary > ANY employee with PositionID 2 */
SELECT FNAME, LNAME, SALARY
FROM EMPLOYEErc
WHERE POSITIONID <> 'P2'
AND SALARY > ANY (
    SELECT SALARY
    FROM EMPLOYEErc
    WHERE POSITIONID = 'P2'
);


/* 17. Employees with maximum salary in their department */
SELECT FNAME, LNAME, SALARY, DEPTID
FROM EMPLOYEErc e
WHERE SALARY = (
    SELECT MAX(SALARY)
    FROM EMPLOYEErc
    WHERE DEPTID = e.DEPTID
);


/* 18. Employee with maximum number of dependents */
SELECT FNAME, LNAME
FROM EMPLOYEErc
WHERE EMPLOYEEID = (
    SELECT EMPLOYEEID
    FROM DEPENDENTrc
    GROUP BY EMPLOYEEID
    HAVING COUNT(*) = (
        SELECT MAX(COUNT(*))
        FROM DEPENDENTrc
        GROUP BY EMPLOYEEID
    )
);


/* 19. Employees with NO dependents (Set operator + subquery) */
SELECT EMPLOYEEID, FNAME, LNAME
FROM EMPLOYEErc
MINUS
SELECT e.EMPLOYEEID, e.FNAME, e.LNAME
FROM EMPLOYEErc e
JOIN DEPENDENTrc d
ON e.EMPLOYEEID = d.EMPLOYEEID;


/* 20. For each dept with >1 employee,
       number earning > 40,000 */
SELECT DEPTID, COUNT(*) AS EMP_COUNT
FROM EMPLOYEErc
WHERE SALARY > 40000
GROUP BY DEPTID
HAVING COUNT(*) > 1;
/* ===================== EXP 6 : VIEWS ===================== */

/* 1. Create a view based on Employee table and display all rows */

CREATE VIEW EMP_VIEW AS
SELECT * FROM EMPLOYEErc;

SELECT * FROM EMP_VIEW;


/* a) Insert record into the view */

INSERT INTO EMP_VIEW
VALUES (901, 'Raj', 'Kumar', 'P1', NULL,
        SYSDATE, 35000, 1000, 10, 'Q1');


/* b) Delete employee whose name is Raj */

DELETE FROM EMP_VIEW
WHERE FNAME = 'Raj';


/* c) Update name Kavi → Kavitha */

UPDATE EMP_VIEW
SET FNAME = 'Kavitha'
WHERE FNAME = 'Kavi';


/* 2. View of employees working in Infosys */

CREATE VIEW INFOSYS_EMP_VIEW AS
SELECT e.*
FROM EMPLOYEErc e
JOIN DEPARTMENTrc d
ON e.DEPTID = d.DEPTID
WHERE d.DEPTNAME = 'Infosys';

SELECT * FROM INFOSYS_EMP_VIEW;


/* 3. Company name and average salary */

CREATE VIEW DEPT_AVG_SAL_VIEW AS
SELECT d.DEPTNAME,
       AVG(e.SALARY) AS AVG_SALARY
FROM EMPLOYEErc e
JOIN DEPARTMENTrc d
ON e.DEPTID = d.DEPTID
GROUP BY d.DEPTNAME;

SELECT * FROM DEPT_AVG_SAL_VIEW;
/* ===================== EXP 7 : DCL COMMANDS ===================== */

/* Create user */

CREATE USER user1 IDENTIFIED BY upass;


/* Change password */

ALTER USER user1 IDENTIFIED BY hruser;


/* Grant system privilege */

GRANT CREATE TABLE TO user1;


/* Grant all privileges */

GRANT ALL TO user1;


/* Grant object privileges */

GRANT SELECT, INSERT, UPDATE, DELETE
ON EMPLOYEErc
TO user1;


/* Grant with grant option */

GRANT SELECT
ON EMPLOYEErc
TO user1
WITH GRANT OPTION;


/* Revoke privileges */

REVOKE INSERT, UPDATE
ON EMPLOYEErc
FROM user1;


/* Revoke system privilege */

REVOKE CREATE TABLE FROM user1;



/* ===================== TCL COMMANDS ===================== */

/* Insert sample record */

INSERT INTO EMPLOYEErc
VALUES (902, 'Anu', 'Nair', 'P2', NULL,
        SYSDATE, 42000, 1000, 20, 'Q2');


/* Save point */

SAVEPOINT sp1;


/* Update salary */

UPDATE EMPLOYEErc
SET SALARY = SALARY + 2000
WHERE EMPLOYEEID = 902;


/* Rollback to savepoint */

ROLLBACK TO sp1;


/* Commit changes */

COMMIT;


/* Delete record */

DELETE FROM EMPLOYEErc
WHERE EMPLOYEEID = 902;


/* Undo delete */

ROLLBACK;
