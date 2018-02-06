# Operational Loss Report

## Scenario

The Risk Management Department in the HQ of Chitty City Bang Bank, Inc. receives data on operational loss events in the different business lines.

The filled out operational loss data templates of each business unit are consolidated by the corresponding office in HQ.  These are collated from the loss data templates they receive from the regional offices.  The data flow is depicted in the diagram below:

> Regional business unit &rarr; HQ business unit &rarr; HQ Risk Management Department

As the resident data scientist in the Risk Management Department in HQ, fashion an operational loss report.  Use the following questions as guidelines:

* Where did losses come from?
* Monitoring for breakdown of controls:
   - mild but frequent losses
   - rare but severe losses
   - recovery rates
* Status of recoveries
* Historical trend of losses

## Datasets

> **Note**: the path `../../Data/*` pertains to a processed data file by jobs under the scenario's `data-source`.
>
> The path `../scenario-name/*` pertains to a processed data files under a different `scenario-name` from the same `data-source`.
>
> A name without a path pertains to a data file in the same `scenario-name`.

| Dataset | Description | Columns | Rows | Input Data | Data Processing Scripts | csv Data File | xlsx Data File | R Data File |
|:--|:--|--:|--:|:-:|:-:|:--|:--|:--|
| Parsed ingest | Consolidated loss events | 12 columns | 1,402 rows | `../../Data/data01_parsed ingest.rds` |  |  |  | [`data01_parsed ingest.rds`](https://drive.google.com/open?id=1GB8wcspcaBwh4ea9FUfCsCrIKQMutQ6N) |
| Reporting frequency | Reporting frequency policy per biz unit | 2 columns | 7 rows | `../../Data/data01_parsed ingest.rds`<br/>`../../Scripts/script01_inspect and parse.ipynb` | `prep01_from deduped ingest.R` |  |  | [`ref00_freq and cats.RData`](https://drive.google.com/open?id=1Jxsnm3NBSEsZTFnpuvNi2lzdvwG1pugV) |
| Risk categories | Risk categories and sub-categories recommended by Basel | 2 columns | 21 rows | `../../Data/data01_parsed ingest.rds`<br/>`../../Scripts/script01_inspect and parse.ipynb` | `prep01_from deduped ingest.R` |  |  | [`ref00_freq and cats.RData`](https://drive.google.com/open?id=1Jxsnm3NBSEsZTFnpuvNi2lzdvwG1pugV) |
| Regional business units reports | Snapshot of file dump collated by regional business units | - | - | `../../Data/data02_deduped ingest.rds` | `prep01_from deduped ingest.R` |  | [`case_Operational Loss Report_raw files/business-unit/region-name/[oprdataq_biz-unit_region-name_period-name.xlsx]!Conso`](https://drive.google.com/open?id=1sjTtdhD0_S6ClQCpOLJtZM_GFliE-SoC) |  |
| Consolidated annual data | Annual data files consolidated per year | - | - | `../../Data/data02_deduped ingest.rds` | `prep01_from deduped ingest.R` |  | [`case_Operational Loss Report_annual conso/[CYyear-name.xlsx]!Bankwide`](https://drive.google.com/open?id=1pX3H4ta8j00IWDKglebO40QrrSL7ZURk) |  |

**Note:** No csv-file is provided because in practice, loss events are encoded into loss data template xlsx-files.

### Loss data template

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
* __Estimated Gross Loss__: Gross loss is a loss before recoveries of any type.
* __Recovery Amount (percent)__<br/>
	![](http://latex.codecogs.com/gif.latex?\frac{\text{Recovery&space;Amount}}{\text{Net&space;Loss}}&space;\cdot&space;100)

### Other data files organization

- [x] The ideal organization of raw data files is:
```
./
└── business-unit/
	└── region-name/
		└── period.xlsx
			└── [period.xlsx]!Conso
			└── [period.xlsx]!Risk Categories
			└── [period.xlsx]!loss-events-per-risk-category
			└── [period.xlsx]!loss-events-per-risk-category
```
How frequent loss data collection is done should vary for the different business units based on the nature of the risks involved; e.g. quarterly for business units prone to high frequency-low severity loss events, or annual for business units subject to low frequency-high severity loss events
- [ ] A more natural set up of simulated raw data files is to exclude *Region* and *Business* from the regional loss data templates since it be inefficient for the regional business units during encoding