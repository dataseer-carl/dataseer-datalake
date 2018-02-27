# Customer Relationship Management

## Scenario

Characterise and identify trends in behaviour of customers:

* Customer life cycle
* Customer purhcasing behaviour (frequency-value)
* Customer segments
* Sales drivers: customer acquisition, price changes, customer behaviour changes

## Datasets

**Note**: the path `../../Data/*` pertains to a processed data file by jobs under the scenario's `data-source`.

The path `../scenario-name/*` pertains to a processed data files under a different `scenario-name` from the same `data-source`.

| Dataset | Description | Columns | Rows | Input Data | Data Processing Scripts | csv Data File | xlsx Data File | R Data File |
|:--|:--|--:|--:|:-:|:-:|:--|:--|:--|
| Fact | Monthly product segment sales per customer | 9 columns | 327,165 rows |  | `../../script01_parse and clean ingest.ipynb` | [`../../Data/data03_Monthly product segment sales per customer.csv`](https://drive.google.com/open?id=1sb4AFDguHUIuLZoaMk4c8t4iwyHo-1GI) |  | [`../../Data/data01_fixed trans and ref.RData`](https://drive.google.com/open?id=10EHYug56KdZTF8hZBgRZYUfMPFL8zxi-) |
| Product segment | Product segment category lookup | 3 columns | 1,415 rows |  | `../../script01_parse and clean ingest.ipynb` |  | [`../../Data/data04_cleaned lookup.xlsx`](https://drive.google.com/open?id=1M0OQJMP57I4rQFwHlZij0PqJJuGvgi0g) | [`../../Data/data01_fixed trans and ref.RData`](https://drive.google.com/open?id=10EHYug56KdZTF8hZBgRZYUfMPFL8zxi-) |
| Customer accounts | Customer lookup | 2 columns | 78 rows |  | `../../script01_parse and clean ingest.ipynb` |  | [`../../Data/data04_cleaned lookup.xlsx`](https://drive.google.com/open?id=1M0OQJMP57I4rQFwHlZij0PqJJuGvgi0g) | [`../../Data/data01_fixed trans and ref.RData`](https://drive.google.com/open?id=10EHYug56KdZTF8hZBgRZYUfMPFL8zxi-) |
| Store list | Store and location lookup | 10 columns | 104 rows |  | `../../script01_parse and clean ingest.ipynb` |  | [`../../Data/data04_cleaned lookup.xlsx`](https://drive.google.com/open?id=1M0OQJMP57I4rQFwHlZij0PqJJuGvgi0g) | [`../../Data/data02_fixed loc ref.RData`](https://drive.google.com/open?id=1HjjP3PddrXlhkChGMSP3lou7hD2IFc98) |
| Districts | District lookup | 3 columns | 9 rows |  | `../../script01_parse and clean ingest.ipynb` |  | [`../../Data/data04_cleaned lookup.xlsx`](https://drive.google.com/open?id=1M0OQJMP57I4rQFwHlZij0PqJJuGvgi0g) | [`../../Data/data02_fixed loc ref.RData`](https://drive.google.com/open?id=1HjjP3PddrXlhkChGMSP3lou7hD2IFc98) |

### Fact

* __MonthID__: Period of summarised transactions
* __LocationID__: Store of transactions
* __CustomerID__: Customer ID of buyer
* __Segment__: Product segment of items purchased by customer in given period and location
* __Sum_GrossMarginAmount__: Sum of "gross profit" of total purchases of a given product segment by a customer in a given period and location
* __Sum_Regular_Sales_Dollars__: Total value of product segment purchases in regular prices made by a customer in a given period and location
* __Sum_Markdown_Sales_Dollars__: Total value of product segment purchases on promo made by a customer in a given period and location
* __Sum_Regular_Sales_Units__: Total number of items per product segment purchased in regular prices made by a customer in a given period and location
* __Sum_Markdown_Sales_Units__: Total number of items per product segment purchased on promo made by a customer in a given period and location

### Product segment

* __Segment__: Product segment ID
* __FamilyName__: Product family ID of segment
* __Category__: Product category of family

### Customer accounts

* __Buyer__: Customer name // Consider separating First from Last name
* __CustomerID__: Customer ID

### Store list

* __LocationID__: Store location ID
* __Name__: Store name
* __Chain__: Retail brand
* __District__: Store district
* __City Name__: City of store address
* __Territory__: State of store address
* __PostalCode__: Postal code of store address
* __OpenDate__: Starting date of operations of store
* __Store Type__: Either `Same Store` or `New Store`
* __SellingAreaSize__: Ranges from 10,000 -- 65,000

### Districts

* __Chain__: Retail brand
* __District__: Store district
* __DM__: District manager
