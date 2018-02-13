# [Uber Movement](https://movement.uber.com/curated/manila?lang=en-PH)

> Uber Movement provides anonymized data from over two billion trips to help urban planning around the world

## Data Files

### [Raw data files](https://drive.google.com/open?id=11D7rbMKUQYG95RldKLeMsKQYYeE6UrHm)

| Filename | Description | Source | Documentation | Columns | Rows | Size |
|:---------|:------------|:-------|:--------------|--------:|-----:|-----:|
| `manila_hexes.json` | Geo boundaries of hex-grid polygons | [`Uber Movement`](https://movement.uber.com/explore/manila/travel-times/) | [`Uber Movement`](https://movement.uber.com/explore/manila/travel-times/) | 3 columns | 846 rows | 361,436 bytes |
| `manila-hexes-2017-2-All-HourlyAggregate.csv` | 2017 Q2 hourly travel times | [`Uber Movement`](https://movement.uber.com/explore/manila/travel-times/) | [`Uber Movement`](https://movement.uber.com/explore/manila/travel-times/) | 7 columns | 6,578,167 rows | 259,610,824 bytes |

### Parsed data files

| Data file | Description | Columns | Rows | Input data | Processing script |
|:--|:--|--:|--:|:--|:--|
| `hex_df.rds` | data.frame of hex-grid properties with coordinates as list of matrices | 3 columns | 846 rows | `manila_hexes.json` | `script00_raw ingest.R` |
| `NCR_hex.RData` |  |  |  | `manila_hexes.json`<br/>`/GADM/PHL_adm_shp/Data/data00_shp_ncr.rds` | `script00_raw ingest.R` |
| *ncr.map* | NCR map tiles |  |  | `manila_hexes.json`<br/>`/GADM/PHL_adm_shp/Data/data00_shp_ncr.rds` | `script00_raw ingest.R` |
| *hex.f* | NCR hexes in tabular form | 7 columns | 5,390 rows | `manila_hexes.json`<br/>`/GADM/PHL_adm_shp/Data/data00_shp_ncr.rds` | `script00_raw ingest.R` |
| *hexNCR.sp* | NCR hexes in polygons |  | 770 rows | `manila_hexes.json`<br/>`/GADM/PHL_adm_shp/Data/data00_shp_ncr.rds` | `script00_raw ingest.R` |

## Datasets

### `manila_hexes.json`

#### Schema

* **MOVEMENT_ID**: hex ID
* **DISPLAY_NAME**: hex centroid marker name
* **coordinates**: list of long-lat

#### Sample

Lorem ipsum

### `manila-hexes-2017-2-All-HourlyAggregate.csv`

#### Schema

* **sourceid**: source hex id
* **dstid**: destination hex id
* **hod**: hour of day
* **mean_travel_time**: (in minutes)
* **standard_deviation_travel_time**: (in minutes)
* **geometric_mean_travel_time**: (in minutes)
* **geometric_standard_deviation_travel_time**: (in minutes)

#### Sample

Lorem ipsum