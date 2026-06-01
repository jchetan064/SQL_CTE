/* CREATE TABLE Employees_CTE (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT,
    manager_id INT,
    hire_date DATE
); */

/* INSERT INTO Employees_CTE VALUES
(101,'Amit','Sales',55000,NULL,'2020-01-15'),
(102,'Priya','HR',60000,NULL,'2019-05-10'),
(103,'Rahul','IT',75000,NULL,'2018-08-20'),
(104,'Sneha','Finance',70000,NULL,'2021-02-12'),
(105,'Vikas','Sales',45000,101,'2022-01-10'),
(106,'Anjali','Sales',50000,101,'2021-06-15'),
(107,'Rohit','HR',42000,102,'2023-03-01'),
(108,'Neha','HR',48000,102,'2022-04-25'),
(109,'Karan','IT',65000,103,'2021-07-19'),
(110,'Meera','IT',72000,103,'2020-11-11'),
(111,'Suresh','Finance',55000,104,'2022-08-05'),
(112,'Pooja','Finance',62000,104,'2021-12-01'),
(113,'Arjun','Sales',47000,101,'2023-02-15'),
(114,'Kriti','Sales',53000,101,'2022-09-09'),
(115,'Deepak','IT',81000,103,'2019-10-10'),
(116,'Riya','IT',69000,103,'2020-05-05'),
(117,'Mohit','HR',51000,102,'2021-01-01'),
(118,'Simran','Finance',58000,104,'2023-04-20'),
(119,'Yash','Sales',46000,101,'2022-06-30'),
(120,'Tanya','IT',73000,103,'2021-08-15'),
(121,'Nitin','Finance',60000,104,'2020-03-12'),
(122,'Isha','HR',47000,102,'2022-11-11'),
(123,'Varun','Sales',52000,101,'2023-01-25'),
(124,'Aisha','IT',76000,103,'2021-05-18'),
(125,'Manoj','Finance',64000,104,'2019-07-22'),
(126,'Kunal','Sales',49000,101,'2022-07-14'),
(127,'Divya','HR',53000,102,'2020-09-09'),
(128,'Abhishek','IT',70000,103,'2023-02-01'),
(129,'Shreya','Finance',61000,104,'2021-04-04'),
(130,'Ajay','Sales',54000,101,'2020-10-20'),
(131,'Nisha','IT',68000,103,'2022-05-01'),
(132,'Rakesh','HR',49000,102,'2021-06-21'),
(133,'Kavita','Finance',59000,104,'2020-08-17'),
(134,'Harsh','Sales',51000,101,'2023-03-12'),
(135,'Payal','IT',74000,103,'2022-09-25'),
(136,'Gaurav','Finance',63000,104,'2021-10-10'),
(137,'Sakshi','HR',52000,102,'2023-01-15'),
(138,'Vivek','Sales',48000,101,'2021-11-30'),
(139,'Tanvi','IT',71000,103,'2020-04-15'),
(140,'Akash','Finance',57000,104,'2022-12-01'),
(141,'Ritu','Sales',50000,101,'2023-04-01'),
(142,'Aman','HR',45000,102,'2022-03-18'),
(143,'Naveen','IT',79000,103,'2019-12-12'),
(144,'Muskan','Finance',65000,104,'2020-06-06'),
(145,'Sahil','Sales',52000,101,'2021-09-09'),
(146,'Komal','HR',54000,102,'2020-02-20'),
(147,'Hemant','IT',67000,103,'2022-07-07'),
(148,'Bhavna','Finance',62000,104,'2021-01-28'),
(149,'Tarun','Sales',47000,101,'2022-10-10'),
(150,'Preeti','IT',72000,103,'2023-05-05'); */

/* Easy */
/* Display all employees earning above company average salary. */
with "Company Salary" as ( select AVG(salary) "Company Avg" from Employees_CTE )
select * from Employees_CTE e join [Company Salary] c on e.salary > c.[Company Avg];


/* Find employees earning above their department average salary. */
with "Department Salary" as ( select AVG(salary) "Department Avg" from Employees_CTE )
select * from Employees_CTE e join [Department Salary] c on e.salary > c.[Department Avg];



/* Show department-wise average salary. */
with "Department Avg Salary" as ( Select Department , AVG( salary ) "Average Salary" from Employees_cte group by Department)
select * from [Department Avg Salary];

/* Find highest-paid employee in each department. */
with "Highest Paid Employee" as ( select * , DENSE_RANK() over(PARTITION by department order by salary desc) "Max Salary" from Employees_cte)
select * from [Highest Paid Employee] where [Max Salary] = 1;


/* Find lowest-paid employee in each department. */
with "Lowest Paid Employee" as ( select * , DENSE_RANK() over(PARTITION by department order by salary asc) "Min Salary" from Employees_cte)
select * from [Lowest Paid Employee] where [Min Salary] = 1;


/* List departments with average salary greater than 60,000. */
with "Department Wise Salary" as ( select Department , AVG(salary) "Avg Salary" from Employees_CTE group by Department )
select * from [Department Wise Salary] where [Avg Salary] > 60000;


/* Find total salary expenditure by department. */
with "Total Salary Expenditure" as ( select Department , SUM(salary) "Total Expenditure" from Employees_CTE group by Department)
select * from [Total Salary Expenditure];


/* Find employees hired after department average hire date. */
with "Average Hiring Date" as ( select Department , AVG(datediff(day,'1990-01-01',hire_date)) "Avg Date" from Employees_CTE group by Department )

select e.* from Employees_CTE e join [Average Hiring Date] a on e.department = a.department where [Avg Date] > a.[Avg Date];


/* Intermediate */
/* Find second-highest salary in each department. */
with "Second Highest Salary" as ( select *,DENSE_RANK() over(partition by department order by salary desc) "Highest Salary" from Employees_CTE)

select * from [Second Highest Salary] where [Highest Salary] = 2;


/* Find top 3 highest-paid employees per department. */
with "Third Highest Salary" as ( select *,DENSE_RANK() over(partition by department order by salary desc) "Highest Salary" from Employees_CTE)

select * from [Third Highest Salary] where [Highest Salary] <= 3;

select * from Employees_CTE order by department asc;

/* Find employees whose salary is greater than their manager's salary. */
with "Manager Salary" as ( select e.emp_id , e.emp_name , e.salary as emp_salary , m.salary as manager_salary from Employees_CTE as e join Employees_CTE as m on e.manager_id = m.emp_id)

select * from "Manager Salary" where emp_salary > manager_salary;


/* Find departments where total salary exceeds 600,000. */
with Dept_Salary as ( select Department,SUM(salary) "Total Salary" from Employees_CTE group by department)
select * from Dept_Salary where [Total Salary] > 600000;


/* Calculate salary difference from department average. */
with Dept_avg as ( select department,AVG(salary) Avg_Salary from Employees_CTE group by department)

select E.emp_name , e.department ,e.salary,d.Avg_Salary, e.salary - d.avg_salary  from Employees_CTE e join dept_avg d on e.department = d.department;


/* Find employees earning in the top 20% of their department. */
with "Salary_Percentage" as (select * , round(PERCENT_RANK() over(partition by department order by salary desc) ,2)"Percent Rank" from Employees_CTE)
select * from Salary_Percentage where "Percent Rank" <= 0.20;


/* Find employees whose salary is above company average and department average. */
with Company_avg as ( select AVG(salary) Comp_avg from Employees_CTE),
Department_avg as ( select Department, AVG(salary) Dept_avg from Employees_CTE group by department)

select e.emp_id,e.emp_name,e.department,e.salary,d.Dept_avg,c.Comp_avg from Employees_CTE	e join Department_avg d on e.department = d.department cross join Company_avg c where e.salary > d.Dept_avg and e.salary > c.Comp_avg;


/* Find department with maximum average salary. */
with dept_rank as ( select Department , AVG(salary) Avg_salary from Employees_CTE group by department )
select * from dept_rank where Avg_salary = ( select MAX(Avg_salary) from dept_rank);


/* Show cumulative salary by hire date within department. */
with Running_Total as (select *,SUM(salary) over(partition by department order by hire_date ) Running_Salary from Employees_CTE)
select * from Running_Total;


/* Find employees hired in the same year as their manager. */
with "Hire Year" as (select e.emp_id , e.emp_name , YEAR(e.hire_date) Emp_Year,m.emp_name manager_name,YEAR(m.hire_date) Manager_Year from  Employees_CTE e join Employees_CTE m on e.manager_id = m.emp_id)

select * from [Hire Year] where Emp_Year = Manager_Year;


/* Advanced */
/* Find department salary ranking using CTE + Window Functions. */
with Dept_total as ( select Department , SUM(salary) Total_Salary from Employees_CTE group by department)

select * , DENSE_RANK() over(order by total_salary desc) Dept_Rank from Dept_total;


/* Identify employees whose salary is within 10% of department maximum. */
with Dept_Max as ( select department , max(salary) Max_Salary from employees_Cte group by department)

select e.* from Employees_CTE e join dept_max d on e.department = d.department where e.salary >= d.Max_salary *0.80;


