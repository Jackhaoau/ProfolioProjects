Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Table 2 Query:
Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
)



Table 1 Insert:
Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

Table 2 Insert:
Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)


select * from EmployeeDemographics

select * from EmployeeSalary

select FirstName,
	   LastName,
	   Gender,
	   Salary,
	   count(gender) over( Partition by gender) TbyG
from EmployeeDemographics Edem
         Join EmployeeSalary ESal
		 on Edem.EmployeeID=Esal.EmployeeID


Select Gender, Count(Gender ) TG from EmployeeDemographics
Group by Gender

;with CTE_Employee as

(Select FirstName,
       LastName,
	   Gender,
	   Salary,
	   count(gender) over (Partition by gender) as T_Gender,
	   avg(salary) over (Partition by gender) as AvgSalary

from EmployeeDemographics ede
join EmployeeSalary es
on ede.EmployeeID= es.EmployeeID
Where salary >45000)

Select FirstName+','+LastName as Name,
Max( Salary) over (Partition by gender) TopSalary


from CTE_Employee
--Group by firstName, lastName
Create Procedure Temp_Employee

@JobTitle Varchar(100)
AS
Drop ##Temp_Employee if Exists
select JobTitle,
       count(jobtitle) as EmployeesPerJob,
	   avg(age) as AvgAge,
	   avg(salary)as AvgSalary  into ##Temp_Employee

from EmployeeDemographics emd
join EmployeeSalary es
on emd.EmployeeID= es.EmployeeID
Where JobTitle =@JobTitle
group by JobTitle


select * from ##Temp_Employee


-----------------------------------------------------------------------


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

	
Select Power(1234,2)

Select * from string_split('1005, TOby, Flenderson - Fired',',')


-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors


-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)



-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors




Select EmployeeID, JobTitle, Salary, Count(EmployeeID) over(Partition by Jobtitle)  as EmNBYDeP 
from EmployeeSalary

Select EmployeeID,
       JobTitle,
	   Salary
from EmployeeSalary

where EmployeeID in ( select EmployeeID from EmployeeDemographics
                     where age between 32 and 34)

Select Power(1234,2)

Select * from string_split('1005, TOby, Flenderson - Fired',',')



;With CTE_Vacc( continent, location, date, population, new_vaccinations, RollingNumberOfVaccinations)
as (
Select dea.continent,
       dea.location,
	   dea.date,
	   dea.population,
	   vac.new_vaccinations,
	   --SUM(CONVERT(int, vac.new_vaccinations)) over (partition by dea.location),   This will give total vac numbers at every row.
	   SUM(CAST(vac.new_vaccinations, int)) over 
	   (Partition By dea.location order by dea,location, dea.date) AS RollingNumberOfVaccinations -- This will give the running number of vaccinations in the group.

from CovidDeaths dea
join  CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3)       order by clause can't be in CTE.

Select continent,
       location,
	   date,
	   population,
	   vac.new_vaccinations,
	   (RollingNumberOfVaccinations/population)*100 as PercentageOfVaccinatedPopu 
From CTE_Vacc


--Useing Temp Table
