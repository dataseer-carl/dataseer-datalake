# Employee Satisfaction and Performance

**Industry**: HR

**Source**: Artificial

|  | DS1 | AVDD | EAN | R | AABD | AI |
|:--|:-:|:-:|:-:|:-:|:-:|:-:|
| Survey results report |  |  |  | x |  |  |
| Attrition reason discovery |  |  |  |  | x |  |

## Scenario

Pharma Drug Inc. has just finished their periodic *Employee Satisfaction* and *Performance Rating* Surveys.

In principle, the aim of the surveys is to answer two questions:

* *How happy are the employees with the company?*
* *How happy is the company with its employees?*

### R

Exercise is to draft a report on the results of the survey; the goal of which is to give a situationer on current levels of satisfaction and performance.  The following skills may be involved:

* Data wrangling for reporting
* Data wrangling for analysis
* Visualization

### AABD

Employee attrition has been particularly high in the recent period.  The typical reason that drive employees to leave the company is dissatisfaction.

The most recent employee satisfaction survey conducted has been able to ask the most recent resignees how satisfied they are about the different aspects of work.

Discover the different segments of resignees and their "dissatisfaction profiles".  Use these to help devise custom employee morale boosting programs.

## Datasets

| Dataset | Description | Input Data | Data Processing Scripts | csv Data File | xlsx Data File | R Data File |
|:--|:--|:-:|:-:|:--|:--|:--|
| Employee records | Employee database maintained by HR; collated from employee profile sheets and employee records database | `data01_parsed ingest.rds` | `prep00_create raw data.R` | `Employee records.csv` | `case_Employee Satisfaction and Performance.xlsx` | `case_Employee Satisfaction and Performance.RData` |
| Performance rating survey | Results of performance rating survey accomplished by managers  | `data01_parsed ingest.rds` | `prep00_create raw data.R` | `Performance rating survey.csv` | `case_Employee Satisfaction and Performance.xlsx` | `case_Employee Satisfaction and Performance.RData` |
| Satisfaction survey | Results of satisfaction survey accomplished by all staff | `data01_parsed ingest.rds` | `prep00_create raw data.R` | `Satisfaction survey.csv` | `case_Employee Satisfaction and Performance.xlsx` | `case_Employee Satisfaction and Performance.RData` |
| Resignee satisfaction levels | Satisfaction survey results of whitelist of resignees | Employee records,<br/>Satisfaction survey | `prep01_resignee satisfaction data.R` | `case_Employee Satisfaction and Performance_resignee satisfaction.csv` | `case_Employee Satisfaction and Performance_resignee satisfaction.xlsx` | `case_Employee Satisfaction and Performance_resignee satisfaction.rds` |

### Schema

#### Employee records

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

#### Performance rating survey

* __EmployeeNumber__: Employee ID
* __PerformanceRating__<br/>
	- *1* 'Low'
	- *2* 'Good'
	- *3* 'Excellent'
	- *4* 'Outstanding'
* __YearsWithCurrManager__: Years with current manager
* __OverTime__: *TRUE*, *FALSE*
* __TrainingTimesLastYear__: Number of trainings attended last year

#### Satisfaction survey

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
	
#### Resignee satisfaction levels

See [Satisfaction survey](#### satisfaction-survey)