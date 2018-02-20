# Production Reliability Monitoring

## Scenario

The COO of a tech manufacturing company noticed that there is a spike in downtime when he reviewed the quarterly production reliabiliy figures.  Investigate the daily logs of supply defects.  Use the ff guide questions:

* Which plants contributed to the sharp increase in downtime?
* How recent did the problems occur?
* Which inputs and stages of the production process were most affected?
* Which materials and from which vendors contributed most to the defects/downtime?

## Datasets

> **Note**: the path `../../Data/*` pertains to a processed data file by jobs under the scenario's `data-source`.
>
> The path `../scenario-name/*` pertains to a processed data files under a different `scenario-name` from the same `data-source`.

| Dataset | Description | Columns | Rows | Input Data | Data Processing Scripts | csv Data File | xlsx Data File | R Data File |
|:--|:--|--:|--:|:-:|:-:|:--|:--|:--|
| Downtime check | Collated downtime logs | 10 columns | 6,145 rows | `../../Data/data01_parsed ingest.rds` | `../../Scripts/script02_clean ingest.R` |  | [`data02_metrics with plant address.xlsx`](https://drive.google.com/open?id=1hj9Fm-EVFxlXKywlE3qcBSMUflJQnfc-) | [`data02_metrics with plant address.RData`](https://drive.google.com/open?id=1hT4IhPdlqTJ8mzlQpDaJrtUQnvxBIHd6) |
| Plant addresses | City and state of plants | 3 columns | 24 rows | `../../Data/data01_parsed ingest.rds` | `../../Scripts/script02_clean ingest.R` |  | [`data02_metrics with plant address.xlsx`](https://drive.google.com/open?id=1hj9Fm-EVFxlXKywlE3qcBSMUflJQnfc-)<br/>[`case_Reliability Monitoring_plant submission/Plant Addresses.xlsx`](https://drive.google.com/open?id=145F4si6OwdAiPa3UiNKq-s8mn-3XolrG) | [`data02_metrics with plant address.RData`](https://drive.google.com/open?id=1hT4IhPdlqTJ8mzlQpDaJrtUQnvxBIHd6) |
| Defect logs | Daily defect and downtime logs per plant | 9 columns |  | `../../Data/data02_metrics with plant address.RData` | `script01_sep data.R` | `case_Reliability Monitoring_plant submission/*.tsv` |  |  |

### Downtime check

* __Date__: ISO 8601 (%Y-%m-%d)
* __Plant__: Plant name where check was conducted
* __Category__: Category of production stage for which check was conducted
* __Vendor__: Supplier of components checked
* __Material Type__: Material type of component checked
* __Defect Type__: Nature of defect --- one of "No Impact", "Impact", and "Rejected"
* __Defect__: Description of defect
* __Defect Qty__: total number of defects
* __Downtime min__: downtime that defect has caused in minutes

### Plant addresses

* __Plant__: Name of plant
* __City__: City of plant
* __State__: State of plant