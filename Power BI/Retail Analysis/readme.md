# [Power BI Retail Analysis](https://docs.microsoft.com/en-us/power-bi/sample-retail-analysis)

> This industry sample dashboard and underlying report analyze retail sales data of items sold across multiple stores and districts. The metrics compare this year’s performance to last year’s in these areas: sales, units, gross margin, and variance, as well as new store analysis.

## Scenario

* Which stores are performing well?
* Which categories are contributing to the increase in sales?
* *markdown units vs regular units sold*
* *high paying customers*

## Data Files

### [Raw data files](https://drive.google.com/open?id=1JEM2_Aa8ehTuon488P27EhG9zK9Um9g_)

| Filename | Description | Source | Documentation | Columns | Rows | Size |
|:---------|:------------|:-------|:--------------|--------:|-----:|-----:|
| **Sales.csv** | Monthly item sales per store | [Power BI](http://download.microsoft.com/download/9/6/D/96DDC2FF-2568-491D-AAFA-AFDD6F763AE3/Retail%20Analysis%20Sample%20PBIX.pbix) | `./Docs/Retail Analysis Sample PBIX.pbix`<br/>`./Docs/relationships.png` | 10 columns | 923,371 | 42,114,725 bytes |
| **Retail Analysis.xlsx** | Lookup tables | [Power BI](http://download.microsoft.com/download/9/6/D/96DDC2FF-2568-491D-AAFA-AFDD6F763AE3/Retail%20Analysis%20Sample%20PBIX.pbix) | `./Docs/Retail Analysis Sample PBIX.pbix`<br/>`./Docs/relationships.png` |  |  | 9,145,174 bytes |
| [Retail Analysis.xlsx]Store! | Store details |  |  | 19 columns | 104 rows |  |
| [Retail Analysis.xlsx]District! | District of stores |  |  | 7 columns | 9 rows |  |
| [Retail Analysis.xlsx]Item! | SKUs: Product categories |  |  | 5 columns | 364,184 rows |  |
| [Retail Analysis.xlsx]Time! | Period |  |  | 5 columns | 734 rows |  |

### [Parsed data files](https://drive.google.com/open?id=1V_tIAOQHSr62U1dWFdOfNJTMDhy0C9z6)

| Data file | Description | Columns | Rows | Input data | Processing script |
|:--|:--|--:|--:|:--|:--|
| `data00_raw ingest.rds` | Raw load of both fact and lookup tables |  |  | `Sales.csv`<br/>`Retail Analysis.xlsx` | `script00_raw ingest.R` |
| `data01_fixed trans and ref.RData` | *cust.ref*, *prod.ref*, *sales.df* |  |  | `Sales.csv`<br/>`[Retail Analysis.xlsx]Item!` | `script01_parse and clean ingest.ipynb` |
| `data02_fixed loc ref.RData` | *district.df*, *store.df* |  |  | `Sales.csv`<br/>`[Retail Analysis.xlsx]Item!` | `script01_parse and clean ingest.ipynb` |
| **`data03_Monthly product segment sales per customer.csv`** | Fixed `Sales.csv` | 9 columns | 327,165 rows | `data01_fixed trans and ref.RData` | `script02_export ingested.R` |
| **`data04_cleaned lookup.xlsx`** | Cleaned lookup tables |  |  |  | `script02_export ingested.R` |
| `[data04_cleaned lookup.xlsx]Customer!` | Customer accounts | 2 columns | 78 rows | `data01_fixed trans and ref.RData` |  |
| `[data04_cleaned lookup.xlsx]Product segment!` | Product segment catalog | 3 columns | 1,415 rows | `data01_fixed trans and ref.RData` |  |
| `[data04_cleaned lookup.xlsx]Store!` | Store list | 10 columns | 104 rows | `data02_fixed loc ref.RData` |  |
| `[data04_cleaned lookup.xlsx]District!` | Lookup for district details of stores | 3 columns | 9 rows | `data02_fixed loc ref.RData` |  |

## Datasets

### `Sales.csv`

#### Schema

* __MonthID__: date format %Y%m
* __ItemID__: lookup table in `[Retail Analysis.xlsx]Item!`
* __LocationID__: lookup table in `[Retail Analysis.xlsx]Store!`
* __Sum_GrossMarginAmount__
* __Sum_Regular_Sales_Dollars__
* __Sum_Markdown_Sales_Dollars__
* __ScenarioID__
* __ReportingPeriodID__: date format %Y%m%d; lookup table in *Time*
* __Sum_Regular_Sales_Units__
* __Sum_Markdown_Sales_Units__

#### Sample

| MonthID | ItemID | LocationID | Sum_GrossMarginAmount | Sum_Regular_Sales_Dollars | Sum_Markdown_Sales_Dollars | ScenarioID | ReportingPeriodID | Sum_Regular_Sales_Units | Sum_Markdown_Sales_Units |
|:-:|:--|:--|--:|--:|--:|:--|:-:|--:|--:|
| 201408 | 256441 | 568 | 4.99 | 9.99 | 0 | 1 | 20140801 | 1 | 0 |

#### Remarks

* There are negative values under *Sum_GrossMarginAmount*.

### `[Retail Analysis.xlsx]District!`

#### Schema

* __DistrictID__
* __District__: District code
* __DM__: Name of District Manager
* __DM_Pic_fl__: URL of picture of District Manager
* __DM_Pic__: Address of picture of District Manager hosted by Obvience; but accessible only to emails included in obvience-public.sharepoint.com directory
* __BusinessUnitID__: dead link
* __DMImage__: Dummy

#### Sample

| DistrictID | District | DM | DM_Pic_fl | DM_Pic | BusinessUnitID | DMImage |
|:--|:-:|:--|:--|:--|:--|:-:|
| 1 | FD - 01 | Valery Ushakov | http://farm6.staticflickr.com/5502/11550929204_d49a132feb_o.jpg | [https://obvience-public.sharepoint.com/SiteAssets/images/demo/people/Valery Ushakov.jpg](https://obvience-public.sharepoint.com/SiteAssets/images/demo/people/Valery Ushakov.jpg) | 3 | System.Byte[] |

#### Remarks

* _Category_ and _Sub Category_ columns are identical.

### [Retail Analysis.xlsx]Item!

#### Schema

* __ItemID__: Product-buyer pair
* __Buyer__: *Last name*, *first name*
* __Category__: Product category of product family [name]
* __FamilyNane__: Family [Name] ID of product segment
* __Segment__: Segment ID of product

#### Sample

| ItemID | Segment | Category | Buyer | FamilyNane |
|:--|:-:|:--|:--|:--|
| 494 | 8599 | 090-Home | Robertson, Lillith | 850 |

### `[Retail Analysis.xlsx]Store!`

#### Schema

* __LocationID__
* __City Name__
* __Territory__
* __PostalCode__
* __OpenDate__: date that store opened in %Y-%m-%d format
* __SellingAreaSize__: Ranges from 10,000 -- 65,000
* __DistrictName__: District code
* __Name__: Store name
* __StoreNumberName__: *StoreNumber* - *Name*
* __StoreNumber__: *StoreID*
* __City__: *City*, *Territory*
* __Chain__: Name of store chain
* __DM__: Name of District Manager
* __DM_Pic__: Address of picture of District Manager hosted by Obvience; but accessible only to emails included in obvience-public.sharepoint.com directory
* __DistrictID__: Reference table in *District* sheet
* __Open Year__: Year store was opened(?)
* __Store Type__: Either `Same Store` or `New Store`
* __Open Month No__: Month store has opened as %m
* __Open Month__: Month store has opened as %b

#### Sample

| LocationID | City Name | Territory | PostalCode | OpenDate | SellingAreaSize | DistrictName | Name | StoreNumberName | StoreNumber | City | Chain | DM | DM_Pic | DistrictID | Open Year | Store Type | Open Month No | Open Month |
|:--|:--|:-:|:-:|:-:|--:|:--|:--|:--|:-:|:--|:--|:--|:-:|:-:|:-:|:-:|:-:|:-:|
| 2 | Weirton | WV | 26032 | 2010-05-01 | 40000 | FD - District #4 | Weirton Fashions Direct | 2 - Weirton Fashions Direct | 2 | Weirton, WV | Fashions Direct | Andrew Ma | [https://obvience-public.sharepoint.com/SiteAssets/images/demo/people/Andrew Ma.jpg](https://obvience-public.sharepoint.com/SiteAssets/images/demo/people/Andrew Ma.jpg) | 4 | 2010 | Same Store | 5 | May |

#### Remarks

* Distinct values for fields pertaining to the district should be identical to the District.
* _OpenDate_ not displayed in cells in Excel but can be seen in formula bar.

### `[Supplier Quality Analysis.xlsx]Time!`

#### Schema

* __ReportingPeriodID__
* __Period__: Period index
* __FiscalYear__: Year in %Y
* __FiscalMonth__: Month in %b
* __Month__: Numeric date(?)

#### Sample

| ReportingPeriodID | Period | FiscalYear | FiscalMonth | Month |
|:-:|:-:|:-:|:-:|--:|
| 20130101 | 1 | 2013 | Jan | 41275 |
