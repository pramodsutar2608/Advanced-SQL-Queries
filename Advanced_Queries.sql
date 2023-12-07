================================================================================

                       ADVANCED LEVEL SQL QUERIES
                                  TOP 20 

================================================================================

1) List the Empno, Ename, Sal, Dname, Exp, and Ann Sal of emps
working for Dept10 or 20.

select * from emp1;
select * from dept;

select a.empno,a.ename,a.sal,b.dname,round(months_between(sysdate,a.hiredate)/12) as Experiance,
       a.sal*30*12 as Annual_sal
from emp1 a,dept b
where a.deptno=b.deptno
and a.deptno in (10,20);

--------------------------------------------------------------------------------

2) List the emps Whose Jobs are same as BLAKE or Sal is more than
FORD.

SELECT * FROM EMP1
WHERE JOB IN (SELECT JOB FROM EMP1 WHERE ENAME='BLAKE')
OR 
SAL > (SELECT SAL FROM EMP1 WHERE ENAME='FORD');

SELECT * FROM EMP1
WHERE JOB IN (SELECT JOB FROM EMP1 A WHERE A.ENAME='BLAKE' AND A.EMPNO<>EMP1.EMPNO)
OR 
SAL > (SELECT SAL FROM EMP1 WHERE ENAME='FORD');

--------------------------------------------------------------------------------

3) List the Emps whose Sal is > the total remuneration of the SALESMAN.

SELECT * FROM EMP1;

SELECT E1.*
FROM EMP1 E1
WHERE E1.SAL > (SELECT SUM(NVL(E2.SAL, 0) + NVL(E2.COMM, 0))
                FROM EMP1 E2
                WHERE E2.JOB = 'SALESMAN');

CASE: Max from all employees in SALESMAN

SELECT * FROM EMP1
WHERE SAL > (SELECT MAX(NVL(SAL,0)+NVL(COMM,0)) FROM EMP1 WHERE JOB='SALESMAN');

--------------------------------------------------------------------------------

4) List the Emps belongs to the dept ACCOUNTING and RESEARCH whose 
Sal is more than BLAKE and exp more than FORD in the asc order of EXP.

select * from emp1;
select * from dept;

select a.empno,a.ename,a.hiredate,
b.dname
from emp1 a,dept b
where a.deptno=b.deptno
and b.dname in ('ACCOUNTING','RESEARCH')
and a.sal > (select sal from emp1 where ENAME='BLAKE')
and a.hiredate < (select hiredate from emp1 where ename='FORD')
order by a.hiredate desc;

--------------------------------------------------------------------------------

5) List the employees who are senior to most recently hired employee
working under king.

select * from emp1;
select * from dept;

select * from emp1
where hiredate<(select max(hiredate) from emp1)
and mgr in (select EMPNO from emp1 where ename='KING');

--------------------------------------------------------------------------------

6) List the details of the employee belongs to newyork except ‘PRESIDENT’ 
whose sal> the highest paid employee of Chicago in a
group where there is manager and salesman not working under king.

select a.* from emp1 a,dept b
where a.deptno=b.deptno
and b.loc='NEW YORK'
and a.JOB NOT IN 'PRESIDENT'
and SAL > (SELECT MAX(SAL) FROM EMP1 a,dept b
       WHERE a.deptno=b.deptno
       and b.LOC='CHICAGO'
       and a.job in ('MANAGER','SALESMAN'))
and mgr not in (select empno from emp1 
                where ename='KING');
 
--------------------------------------------------------------------------------
7) List the employees whose salary is more than 3000 after giving 20% increment.

select * from emp1;

select * from emp1 
where (sal*1.20)>3000;

--------------------------------------------------------------------------------
 
8) List the name,salary,comm. For those employees whose net pay is
greater than or equal to any other employee salary of the company.

select e.ename,e.sal,e.comm from emp1 e where
nvl2(e.comm,e.sal+e.comm,e.sal) >= any (select sal from emp1); 

--------------------------------------------------------------------------------

9) List the emp whose sal<his manager but more than any other manager.

Table
select * from emp1 a,emp1 b where a.mgr = b.empno and a.sal < b.sal
and a.sal > any (select sal from emp1 where empno in (select mgr from emp1));

--------------------------------------------------------------------------------

10) Find out least 5 earners of the company.

select rownum rank,empno,ename,job,sal from (select * from emp1 order by
sal asc) where rownum < 6 ;

with cte as (
select dense_rank() over (order by sal asc) as rank,
empno,ename,job,sal from emp1
)
select a.* from cte a
where rank<6;

--------------------------------------------------------------------------------

11) List the Name , Salary, Comm and Net Pay is more than any other
employee.

select ename,sal,comm, nvl2(comm,comm+sal,sal) as Net_Pay from emp1
where nvl2(comm,comm+sal,sal) > any(select sal from emp1);

--------------------------------------------------------------------------------

12) List first 50% of chars of Ename in Lower Case and remaining are upper Case.

select  lower(substr(ename,1,round(length(ename)/2))) || upper(substr(ename,round(length(ename)/2)+1))  
from emp1;

--------------------------------------------------------------------------------
13) List the Dname whose No. of Emps is equal to number of chars in the Dname.

select * from emp1;
select * from dept;
select b.dname,count(*) from emp1 a,dept b
where a.deptno=b.deptno
group by dname
having count(*)=length(b.dname);

--------------------------------------------------------------------------------

14) List THE Name of dept where highest no.of emps are working.

select a.deptno,b.dname,count(*) from emp1 a,dept b
where a.deptno=b.deptno
group by a.deptno,b.dname
order by count(*) desc
fetch first 1 rows only;

--------------------------------------------------------------------------------

15) List the emps who joined in the company on the same date.

select * from emp1 e where hiredate in
(select hiredate from emp1 where e.empno <> empno);

select unique a.* from emp1 a,emp1 b
where a.hiredate=b.hiredate
and a.empno<>b.empno;

--------------------------------------------------------------------------------

16) Print a list of emp’s Listing "Just Salary" if Salary is more than 1500, 
"On Target" if Salary is 1500 and Below 1500,"Null" if Salary is less than 1500.

select empno,ename,sal,
case
when sal>1500 then 'Just Salary'
when sal<=1500 then 'On Target'
else 'Null' 
end 
from emp1;

--------------------------------------------------------------------------------

17) List those Managers who are getting less than his emps Salary.

select * from emp1 a,emp1 b 
where a.mgr = b.empno 
and a.sal > b.sal;

--------------------------------------------------------------------------------

18) Find out the emps who joined in the company before their Managers.

select * from emp1 a,emp1 b where a.mgr = b.empno and
a.hiredate< b.hiredate;

--------------------------------------------------------------------------------

19) List the emps along with loc of those who belongs to dallas ,New York with
sal ranging from 2000 to 5000 joined in 81.

select e.empno,e.ename,e.deptno,e.sal,d.loc from emp1 e ,dept d
where e.deptno = d.deptno and d.loc in ('NEW YORK','DALLAS')
and to_char(e.hiredate,'YY') = '81' and e.sal between 2000 and 5000;

--------------------------------------------------------------------------------
 
20) List the mgrs who are senior to king and who are junior to smith.

select * from emp1 where empno in
(select mgr from emp1
where hiredate<(select unique hiredate from emp1 where ename = 'KING' )
and hiredate > (select hiredate from emp1 where ename = 'SMITH')) and mgr
is
not null;

--------------------------------------------------------------------------------

21) List the highest paid emp working under king.

select * from emp1
where sal in (select max(sal) from emp1
              where mgr in (select empno from emp1
                            where ename='KING'));
                            
--------------------------------------------------------------------------------
