# Employee Satisfaction and Performance

**Industry**: HR

**Source**: Artificial

## Scenario

Every quarter, Pharma Drug Inc. conducts two employee surveys: an *employee satisfaction survey* and a *performance rating survey*.

Using the results from these two surveys *and* data from Pharma Drug's employee records, draft a report that answers the ff questions:

* *How happy are the employees with the company?*
* *How happy is the company with its employees?*

## Datasets

| Dataset | Description | Input Data | Data Processing Scripts | csv Data File | xlsx Data File | R Data File |
|:--|:--|:-:|:-:|:--|:--|:--|
| Employee records | Employee database maintained by HR; collated from employee profile sheets and employee records database | `../data01_parsed ingest.rds` | `prep00_create raw data.R` | [`Employee records.csv`](https://drive.google.com/open?id=1rKSduE2E2ZX5lk1a4PmLd6oSstd9WAW2) | [`case_Employee Satisfaction and Performance.xlsx`](https://drive.google.com/open?id=1sPGGAEs5uOvlUcok0bJiVMv5RKqe05MJ) | [`case_Employee Satisfaction and Performance.RData`](https://drive.google.com/open?id=1Ho1NEvBNqGhxKVurONaL1xe9tEdHkVW4) |
| Performance rating survey | Results of performance rating survey accomplished by managers  | `data01_parsed ingest.rds` | `prep00_create raw data.R` | [`Performance rating survey.csv`](https://drive.google.com/open?id=1TNp9wS8oozEeLQmenWVbxhGnkiraZu2T) | [`case_Employee Satisfaction and Performance.xlsx`](https://drive.google.com/open?id=1sPGGAEs5uOvlUcok0bJiVMv5RKqe05MJ) | [`case_Employee Satisfaction and Performance.RData`](https://drive.google.com/open?id=1Ho1NEvBNqGhxKVurONaL1xe9tEdHkVW4) |
| Satisfaction survey | Results of satisfaction survey accomplished by all staff | `data01_parsed ingest.rds` | `prep00_create raw data.R` | [`Satisfaction survey.csv`](https://drive.google.com/open?id=1rtWqWPZz58E4YvxMA-ygM-tRPmWNyNB5) | [`case_Employee Satisfaction and Performance.xlsx`](https://drive.google.com/open?id=1sPGGAEs5uOvlUcok0bJiVMv5RKqe05MJ) | [`case_Employee Satisfaction and Performance.RData`](https://drive.google.com/open?id=1Ho1NEvBNqGhxKVurONaL1xe9tEdHkVW4) |

### Employee records

* __EmployeeNumber__: Employee ID
* __Sex__: *Male* or *Female*
* __Age__: Employee age
* __MaritalStatus__: *Single*, *Married*, *Divorced*
* __DistanceFromHome__: Distance of work from home (in km?).  Ranges from 1--29.  29km ~ Makati to San Pedro, Laguna
* __Education__<br/>
	- *1* 'Below College'
	- *2* 'College'
	- *3* 'Bachelor'
	- *4* 'Master'
	- *5* 'Doctor'
* __EducationField__<br/>
	- *Human Resources*
	- *Life Sciences*
	- *Marketing*
	- *Medical*
	- *Technical degree*
	- *Other*
* __NumCompaniesWorked__: Number of companies worked with prior
* __TotalWorkingYears__: Total number of years working
* __Department__<br/>
	- *Sales*
	- *Research & Development*
	- *Human Resources*
* __JobLevel__: Ranges from 1--5
* __JobRole__: Job title
* __YearsAtCompany__: Tenure
* __YearsInCurrentRole__: Years in current role
* __YearsSinceLastPromotion__: Years since last promotion
* __MonthlyIncome__: Current salary
* __StockOptionLevel__: Ranges 0--3
* __SalaryHike__: Increase in salary (in percent) from base?)
* __Separated__: Has employee left the company: *TRUE*, *FALSE*

### Performance rating survey

* __EmployeeNumber__: Employee ID
* __PerformanceRating__<br/>
	- *1* 'Low'
	- *2* 'Good'
	- *3* 'Excellent'
	- *4* 'Outstanding'
* __YearsWithCurrManager__: Years with current manager
* __OverTime__: *TRUE*, *FALSE*
* __TrainingTimesLastYear__: Number of trainings attended last year

### Satisfaction survey

* __EmployeeNumber__: Employee ID
* __EnvironmentSatisfaction__: *How satisfied are you with your working environment?*
	- *1* 'Low'
	- *2* 'Medium'
	- *3* 'High'
	- *4* 'Very high'
* __RelationshipSatisfaction__: *How satisfied are you with the relationship with your co-workers?*
	- *1* 'Low'
	- *2* 'Medium'
	- *3* 'High'
	- *4* 'Very high'
* __JobSatisfaction__: *How satsified are you with your job?*
	- *1* 'Low'
	- *2* 'Medium'
	- *3* 'High'
	- *4* 'Very high'
* __JobInvolvement__: *How much involved do you feel at work?* (Employee engagement)
	- *1* 'Low'
	- *2* 'Medium'
	- *3* 'High'
	- *4* 'Very high'
* __WorkLifeBalance__: *How much work-life balance do you feel you have?*
	- *1* 'Bad'
	- *2* 'Good'
	- *3* 'Better'
	- *4* 'Best'