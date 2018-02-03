# Employee Retention

## Scenario

The first year of operations of Pharma Drug Inc. has just ended, and some of its employees have decided to leave the company.

As a company that just started, the HR Director of the company wants to proactively engage their employees.  The director wants to know:

* Who among the current employees are most prone to leaving the company; and
* Why did the resignees leave the company?

### Employee retention model

Using the *historical employees* data, a predictive model for employee separation can be constructed.  This model can then be applied on *active employees* data to predict who among them are most at risk of separation.

Note that because of the lack of temporal depth in the data, a proper predictive exercise that demonstrates all the facets of predictive analytics cannot be devised.

### Employee program design

The responses of the resigness in the recently conducted *Employee Satisfaction Survey* can be used to understand the different dissatisfaction profiles.  The segments of dissatisfied employees can provide invaluable inputs to designing employee engagement programs.

When a predictive model for what "dissatisfaction segments" active employees would belong in is constructed, it could be used in conjunction with the *predictive employee retention model* to come up with targeted programs.

## Datasets

> **Note**: the path `../../Data/*` pertains to a processed data file by jobs under the scenario's `data-source`.
>
> The path `../scenario-name/*` pertains to a processed data files under a different `scenario-name` from the same `data-source`.
>
> A name without a path pertains to a data file in the same `scenario-name`.

| Dataset | Description | Columns | Rows | Input Data | Data Processing Scripts | csv Data File | xlsx Data File | R Data File |
|:--|:--|--:|--:|:-:|:-:|:--|:--|:--|
| Historical employees | List of all current and past employees | 16 columns | 1,470 rows | `../../Data/data01_parsed ingest.rds` | `prep00_from parsed ingest.R` | [`active employees.csv`](https://drive.google.com/open?id=12Mwh0ljlAi1omGnGe7PbP7PztgiXje-n) | [`case_Employee Retention.xlsx`](https://drive.google.com/open?id=1CxkT11f8GHs37j3t2t0GW4auwqjLzKDO) | [`case_Employee Retention.RData`](https://drive.google.com/open?id=1lAExdSn6t5_tQgZ8eSf-zlWjsOS7v5OP) |
| Active employees | List of all current employees | 19 columns | 1,233 rows | Historical employees<br/>`../../Data/sdata01_parsed ingest.rds` | `prep00_from parsed ingest.R` | [`all employees.csv`](https://drive.google.com/open?id=1HqFqrH4miMX0cHcVmlElspTkdnfKUTMl) | [`case_Employee Retention.xlsx`](https://drive.google.com/open?id=1CxkT11f8GHs37j3t2t0GW4auwqjLzKDO) | [`case_Employee Retention.RData`](https://drive.google.com/open?id=1lAExdSn6t5_tQgZ8eSf-zlWjsOS7v5OP) |
| Satisfaction survey | Results of satisfaction survey accomplished by all staff | 6 columns | 1,470 rows | `../../Data/data01_parsed ingest.rds` | `../Employee Satsifaction and Performance/prep00_from parsed ingest.R` | [`Satisfaction survey.csv`](https://drive.google.com/open?id=1XbTDzUDbKPyz8ZTFIHRYa0u5FRxIceNl) | [`case_Employee Satisfaction and Performance.xlsx`](https://drive.google.com/open?id=1tpYNejB06-NvbSgA37jxpu0QAEMO8Fmg) | [`case_Employee Satisfaction and Performance.RData`](https://drive.google.com/open?id=1PnW8k9y6k6S45iaoUN2x0hFp5gP51obk) |

### All employees

* __EmployeeNumber__: Employee ID
* __Sex__: *Male* or *Female*
* __Age__: Current age of employee
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
* __priorNumCompaniesWorked__: Number of companies worked with prior to the company.
* __priorYearsOfWork__: Total number of years of working experience prior to the company.
* __Tenure__: Total number of years working in the company.
* __lastDepartment__: Current department if active; last department if inactive
	- *Sales*
	- *Research & Development*
	- *Human Resources*
* __lastJobLevel__: Current job level if active; last job level if inactive.  Ranges from 1--5
* __lastJobRole__: Current job title if active; last job title if inactive.
* __lastMonthlyIncome__: Current salary if active; last salary if inactive.
* __lastStockOptionLevel__: Current stock option level if active; last if inactive.  Ranges 0--3
* __OverTime__: Whether employee has worked over time or not
* __Status__: `Active` if current employee; `Inactive` if separated from company.

### Active employees

* __EmployeeNumber__: Employee ID
* __Sex__: *Male* or *Female*
* __Age__: Current age of employee
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
* __priorNumCompaniesWorked__: Number of companies worked with prior to the company.
* __priorYearsOfWork__: Total number of years of working experience prior to the company.
* __Tenure__: Total number of years working in the company.
* __Department__: Current department of employee.
	- *Sales*
	- *Research & Development*
	- *Human Resources*
* __JobLevel__: Current job level of employee.  Ranges from 1--5.
* __JobRole__: Current job title of employee.
* __MonthlyIncome__: Current monthly salary.
* __StockOptionLevel__: Current stock option level.  Ranges 0--3.
* __OverTime__: Whether employee has worked over time or not
* __YearsInCurrentRole__: Years in current role.
* __YearsSinceLastPromotion__: Number of years since last promotion
* __SalaryHike__: Increase in salary by last promotion

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
* __JobInvolvement__: *How engaged are you at work?*
	- *1* 'Low'
	- *2* 'Medium'
	- *3* 'High'
	- *4* 'Very high'
* __WorkLifeBalance__: *How much work-life balance do you feel you have?*
	- *1* 'Bad'
	- *2* 'Good'
	- *3* 'Better'
	- *4* 'Best'