# [IBM Watson Banking Loss Events](https://www.ibm.com/communities/analytics/watson-analytics-blog/guide-to-sample-datasets/)

> Understand hidden patterns and trends by combining various fields in Explore. Predict the leading drivers of a target, for example, using 'Recovery Amount' as the target.

## Data Files

### [Raw data files](https://drive.google.com/open?id=1kGYrOyEqZIAw07jOuklSIF9BbEIBZkL9)

| Filename | Description | Source | Documentation | Columns | Rows | Size |
|:---------|:------------|:-------|:--------------|--------:|-----:|-----:|
| `WA_Fn-UseC_-Banking-Loss-Events-2007-14.xlsx` | [Operational] loss data template | [Watson Analytics](https://community.watsonanalytics.com/wp-content/uploads/2015/03/WA_Fn-UseC_-Banking-Loss-Events-2007-14.xlsx) | [BCBS](https://www.bis.org/bcbs/publications.htm?a=1&tid=28&mp=any&pi=title&bv=list&tid=28)<br/>`./Docs/d355.pdf`<br/>`./Docs/bcbs196.pdf`<br/>`./Docs/bcbs195.pdf`<br/>`./Docs/oprdataq.xls` | 13 columns | 1,402 rows | 598,389 bytes |

### [Parsed data files](https://drive.google.com/open?id=16DUp_e_asEP8LjmXfVqzEj6efqB44qvP)

| Data file | Description | Columns | Rows | Input data | Processing script |
|:--|:--|--:|--:|:--|:--|
| `data00_raw ingest.rds` | Loaded raw data | 13 columns | 1,402 rows | `WA_Fn-UseC_-Banking-Loss-Events-2007-14.xlsx` | `script00_raw ingest.R` |
| `data01_parsed ingest.rds` | Cleaned raw data | 12 columns | 1,402 rows | `data00_raw ingest.rds` | `script01_inspect and parse.ipynb` |

#### Unresolved issues

- [ ] Duplicate rows because of multiple *Recovery Amounts (percent)*.  As some entries in the loss data template are updated, duplicate rows are created.  Would result in double-counting if not resolved.
- [ ] Different *year of discovery* from *year of occurrence*.  Not an issue of discovered before occurrence; but discovery after occurrence would cause retroactive adjustments to reports.

## Datasets

### `WA_Fn-UseC_-Banking-Loss-Events-2007-14.xlsx`

#### Schema

* __Region__: Region of event.
* __Business__: Business line affected.
* __Name__: Key; name of event.
* __Status__: Status of recovery; sequence of status updates unknown
* __Risk Category__: Level 1 risk category.
	- *Clients, Products and Business Practices*: market manipulation, antitrust, improper trade, product defects, fiduciary breaches, account churning
	- *Execution, Delivery and Process Management*: data entry errors, accounting errors, failed mandatory reporting, negligent loss of client assets
	- *Employment Practices and Workplace Safety*: discrimination, workers compensation, employee health and safety
	- *Internal Fraud*: misappropriation of assets, tax evasion, intentional mismarking of positions, bribery
	- *External Fraud*: theft of information, hacking damage, third-party theft and forgery
	- *Damage to Physical Assets*: natural disasters, terrorism, vandalism
	- *Business Disruption and System Failures*: utility disruptions, software failures, hardware failures
* __Risk Sub-Category__: Level 2 risk category.
* __Discovery Date__: Date of discovery of loss event.  Ranges from `2007-01-02` to `2014-12-23`.
* __Occurrence Start Date__: Starting date of occurrence of loss event.  Ranges from `2007-01-02` to `2014-12-26`.
* __Year__: Year of occurrence.
* __Net Loss__: Net loss is defined as the loss after taking into account the impact of recoveries.
* __Recovery Amount__: The recovery is an independent occurrence, related to the original loss event, separate in time, in which funds or inflows of economic benefits are received from a third party.
* __Estimated Gross Loss__: is a loss before recoveries of any type.
* __Recovery Amount (percent)__<br/>
	![](http://latex.codecogs.com/gif.latex?\frac{\text{Recovery&space;Amount}}{\text{Net&space;Loss}}&space;\cdot&space;100)

#### Sample

| Region | Business | Name | Status | Risk Category | Risk Sub-Category | Discovery Date | Occurrence Start Date | Year | Net Loss | Recovery Amount | Estimated Gross Loss | Recovery Amount (percent) |
|:--|:--|:--|:-:|:--|:--|:-:|:-:|:-:|--:|--:|--:|--:|
| EMEA | Retail Brokerage | LE−06−2 | Under Review | Clients, Products and Business Practices | Product Flaws | 1-Jan-2007 | 2-Jan-2007 | 2007 | 296,555 | 83,035 | 291,100 | 28 |
