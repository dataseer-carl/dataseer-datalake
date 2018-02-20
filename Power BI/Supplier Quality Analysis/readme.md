# [Power BI Supplier Quality Analysis](https://docs.microsoft.com/en-us/power-bi/sample-supplier-quality)

> This industry sample focuses on one of the typical supply chain challenges — supplier quality analysis. Two primary metrics are at play in this analysis: total number of defects and the total downtime that these defects caused. This sample has two main objectives: understand who the best and worst suppliers are, with respect to quality; and identify which plants do a better job finding and rejecting defects, to minimize downtime.

## Data Files

### [Raw data files](https://drive.google.com/open?id=1t9FQbFzPXoQlAeifBw7SfrR0eP2X_CwT)

| Filename | Description | Source | Documentation | Columns | Rows | Size |
|:---------|:------------|:-------|:--------------|--------:|-----:|-----:|
| **Supplier Quality Analysis.xlsx** |  | [Power BI](http://download.microsoft.com/download/8/C/6/8C661638-C102-4C04-992E-9EA56A5D319B/Supplier-Quality-Analysis-Sample-PBIX.pbix) | `./Docs/Supplier-Quality-Analysis-Sample-PBIX.pbix`<br/>`./Data/relationships.png` |  |  | 344,074 bytes |
| [Supplier Quality Analysis.xlsx]Metrics! | Data |  |  | 10 columns | 6,145 rows |  |
| [Supplier Quality Analysis.xlsx]Category! | Lookup table for production process phase |  |  | 3 columns | 6 rows |  |
| [Supplier Quality Analysis.xlsx]Date! | Lookup table for dates |  |  | 5 columns | 1,096 rows |  |
| [Supplier Quality Analysis.xlsx]Defect! | Lookup table for description of defect |  |  | 2 columns | 305 rows |  |
| [Supplier Quality Analysis.xlsx]Defect Type! | Lookup table for defect type |  |  | 3 columns | 3 rows |  |
| [Supplier Quality Analysis.xlsx]Material Type! | Lookup table for material of component affected/inspected |  |  | 2 columns | 22 rows |  |
| [Supplier Quality Analysis.xlsx]Plant! | Lookup table for plant |  |  | 2 columns | 24 rows |  |
| [Supplier Quality Analysis.xlsx]Vendor! | Lookup table for supplier |  |  | 2 columns | 328 rows |  |


### [Parsed data files](https://drive.google.com/open?id=1sXqp5Pz2PsalfnZKFmcTneRfCJynUOLx)

| Data file | Description | Columns | Rows | Input data | Processing script |
|:--|:--|--:|--:|:--|:--|
| `data00_raw ingest.rds` | Loaded raw data and lookup tables |  |  | `Supplier Quality Analysis.xlsx` | `script00_raw ingest.R` |
| `data01_parsed ingest.rds` | Cleaned raw data with lookup values | 9 columns | 6,145 rows | `data00_raw ingest.rds` | `script01_parse ingest.R` |
| `data02_metrics with plant address.xlsx` | With lookup table for *City* and *State* of *Plant* |  |  | `data01_parsed ingest.rds` | `script02_clean ingest.R` |
| `data02_metrics with plant address.RData` | With lookup table for *City* and *State* of *Plant* |  |  | `data01_parsed ingest.rds` | `script02_clean ingest.R` |

## Datasets

### `[Supplier Quality Analysis.xlsx]Metrics!`

#### Schema

* __Date__: ISO 8601 (%Y-%m-%d)
* __Sub Category ID__: reference table in *Category* sheet
* __Plant ID__: reference table in *Plant* sheet
* __Vendor ID__: reference table in *Vendor* sheet
* __Material ID__: dead link
* __Defect Type ID__: reference table in *Defect Type* sheet
* __Material Type ID__: reference table in *Material Type* sheet
* __Defect ID__: reference table in *Defect* sheet
* __Defect Qty__: total number of defects
* __Downtime min__: downtime that defect has caused in minutes

#### Sample

| Date | Sub Category ID | Plant ID | Vendor ID | Material ID | Defect Type ID | Material Type ID | Defect ID | Defect Qty | Downtime min |
|:-:|:-:|:--|:--|:--|:-:|:-:|:-:|--:|--:|
| 2014-12-01 | 6 | 10 | 173 | 959 | 1 | 9 | 247 | 0 | 0 |

#### Remarks

Values under *Date* column not visible from sheet, but can be seen in formula bar.

### `[Supplier Quality Analysis.xlsx]Category!`

#### Schema

* __Sub Category__
* __Sub Category ID__
* __Category__

#### Sample

| Sub Category | Sub Category ID | Category |
|:--|:-:|:--|
| Electrical | 1 | Electrical |

#### Remarks

*Category* and *Sub Category* columns are identical.

### `[Supplier Quality Analysis.xlsx]Date!`

#### Schema

* __Year__
* __MonthNumber__
* __Week__
* __Date__
* __Month__

#### Sample

| Year | MonthNumber | Week | Date | Month |
|:-:|--:|--:|:-:|:-:|
| 2012 | 1 | 1 | 2012-01-01 | Jan |

#### Remarks

Values under *Date* column not visible from sheet, but can be seen in formula bar.

### `[Supplier Quality Analysis.xlsx]Defect!`

#### Schema

* __Defect__: Description of defect
* __Defect ID__

#### Sample

| Defect | Defect ID |
|:--|:-:|
| Dimensions - Bad Finishing | 1 |

### `[Supplier Quality Analysis.xlsx]Defect Type!`

#### Schema

* __Defect Type__: one of `No Impact`, `Impact`, or `Rejected`
* __Defect Type ID__
* __Sort__

#### Sample

| Defect Type | Defect Type ID | Sort |
|:--|:--|--:|
| No Impact | 1 | 3 |

### `[Supplier Quality Analysis.xlsx]Material Type!`

#### Schema

* __Material Type__
* __Material Type ID__

#### Sample

| Material Type | Material Type ID |
|:--|:-:|
| Corrugate | 1 |

### `[Supplier Quality Analysis.xlsx]Plant!`

#### Schema

* __Plant__: City, State
* __Plant ID__

#### Sample

| Plant | Plant ID |
|:--|:-:|
| Grand Rapids, MI | 1 |

### `[Supplier Quality Analysis.xlsx]Vendor!`

#### Schema

* __Vendor__: Name of vendor
* __Vendor ID__

#### Sample

| Vendor | Vendor ID |
|:--|:-:|
| Reddoit | 1 |