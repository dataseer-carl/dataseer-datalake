# Salary Benchmarking

## Scenario

The Salaries & Benefits Officer of Pharma Drug Inc. wants to systematise the determination of offers and raises.

Using the company's employee records, construct a pay plan that will provide a recommended offer or raise based on the candidate's profile and work experience.  Consider how this pay plan will be presented and how it will be implemented.

## Datasets

> **Note**: the path `../../Data/*` pertains to a processed data file by jobs under the scenario's `data-source`.
>
> The path `../scenario-name/*` pertains to a processed data files under a different `scenario-name` from the same `data-source`.
>
> A name without a path pertains to a data file in the same `scenario-name`.

| Dataset | Description | Columns | Rows | Input Data | Data Processing Scripts | csv Data File | xlsx Data File | R Data File |
|:--|:--|--:|--:|:-:|:-:|:--|:--|:--|
| Employee record | Employee bio, work experience, current employment | 16 columns | 1,470 rows | `../../Data/data01_parsed ingest.rds` | `prep00_from parsed ingest.R` | [`employee record.csv`](https://drive.google.com/open?id=1sxojpwo5KUzvF4JuR3fUUul27fsxWF1g) | [`case_Salary Benchmarking.xlsx`](https://drive.google.com/open?id=1yaLU5pShIWcDBHUIHMSDTJC9gPBRizFB) | [`case_Salary Benchmarking.RData`](https://drive.google.com/open?id=1Z-nIIM9RckoVnltAqaYURA8oUHHuwJup) |

### Employee record

* __EmployeeNumber__: Employee ID
* __Sex__: *Male* or *Female*
* __Age__: Employee age
* __MaritalStatus__: *Single*, *Married*, *Divorced*
* __DistanceFromHome__: Distance of work from home (in km?).  Ranges from 1--29.  29km ~ Makati to
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
* __Department__: *Sales*, *Research & Development*, *Human Resources*
* __JobLevel__: Ranges from 1--5
* __JobRole__: Job title
* __StockOptionLevel__: Ranges 0--3
* __MonthlyIncome__: Current monthly salary