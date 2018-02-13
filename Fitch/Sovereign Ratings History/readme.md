# [Sovereign Ratings History](https://quant.stackexchange.com/questions/739/are-public-historical-time-series-available-for-ratings-of-sovereign-debt)

> Log of changes in Fitch sovereign ratings per country.

## Data Files

### [Raw data files](https://drive.google.com/open?id=1sIweKr8lX6hWplh1F6vuz-lOv1sUs22_)

| Filename | Description | Source | Documentation | Columns | Rows | Size |
|:---------|:------------|:-------|:--------------|--------:|-----:|-----:|
| `sovereign_ratings_history.xls` | Log of changes in Fitch sovereign ratings | [`fitchratings.com`](https://www.fitchratings.com/web_content/ratings/sovereign_ratings_history.xls) | [`fitchratings.com`](https://www.fitchratings.com/site/definitions) | 7 columns | 983 rows | 193,024 bytes |

### Parsed data files

| Data file | Description | Columns | Rows | Input data | Processing script |
|:--|:--|--:|--:|:--|:--|
| `ref_ratings` | Short-term and long-term rating levels |  |  | `sovereign_ratings_history.xls` | `script00_raw ingest.R` |
| `data00_sanitised rating actions.rds` | Cleaned ratings changes log | 7 columns | 980 rows | `sovereign_ratings_history.xls` | `script00_raw ingest.R` |
| `data00_sanitised rating actions.csv` | Cleaned ratings changes log | 7 columns | 980 rows | `sovereign_ratings_history.xls` | `script00_raw ingest.R` |

## Datasets

### `sovereign_ratings_history.xls`

#### Schema

* __Country__
* __Date__<br/>
	Date of ratings update.
* __Foreign currency rating, long-term__: Foreign Currency Ratings additionally consider the profile of the issuer or note after taking into account T&C risk. This risk is usually communicated for different countries by the Country Ceiling, which caps the foreign currency ratings of most, though not all, issuers within a given country.
* __Foreign currency rating, short-term__: Lorem ipsum
* __Foreign currency rating, outlook/Watch__: Outlooks indicate the direction a rating is likely to move over a one- to two-year period.  Ratings in the ‘CCC’, ‘CC’ and ‘C’ categories typically do not carry Outlooks since the  volatility of these ratings is very high and outlooks would be of limited informational value. Defaulted ratings do not carry Outlooks. Rating Watches indicate that there is a heightened probability of a rating change and the likely direction of such a change.
* __Local currency rating, long-term__: The Local Currency International Rating measures the likelihood of repayment in the currency of the jurisdiction in which the issuer is domiciled and hence does not take account of the possibility that it will not be possible to convert local currency into foreign currency or make transfers between sovereign jurisdictions (transfer and convertibility [T&C] risk).
* __Local currency rating, outlook/Watch__: Outlooks indicate the direction a rating is likely to move over a one- to two-year period.  Ratings in the ‘CCC’, ‘CC’ and ‘C’ categories typically do not carry Outlooks since the  volatility of these ratings is very high and outlooks would be of limited informational value. Defaulted ratings do not carry Outlooks. Rating Watches indicate that there is a heightened probability of a rating change and the likely direction of such a change.

#### Sample

| Country | Date | long-term | short-term | outlook/Watch | long-term | outlook/Watch |
|:--|:-:|:-:|:-:|:-:|:-:|:-:|
| Abu Dhabi | 2 Jul 2007 | AA | F1+ | stable | AA | stable |

#### Remarks

> Last updated: 24 Aug 2012
>
> 1. blue = positive rating action, red = negative rating action.
> 1. DCR history kept for the 4 sovereigns not rated by Fitch IBCA prior to the merger with Duff & Phelps and affirmed 19/5/00 by Fitch.  
> 1. Outlooks assigned to all ratings, and used as a rating action starting from  21/9/00.
> 1. Separate and distinct FC and LC Rating Outlooks used, allowing them to differ starting from 1/10/03.
> 1. Rating affirmations are not listed, but are available from FitchResearch

Rating outlooks actually are compound variables; whether or not a `Rating Watch` has been indicated is a separate variable.
