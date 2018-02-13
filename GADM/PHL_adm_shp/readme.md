# [PHL_adm_shp](http://gadm.org/country)

> GADM is a spatial database of the location of the world's administrative areas (or adminstrative boundaries) for use in GIS and similar software.

## Data Files

### [Raw data files](https://drive.google.com/open?id=1WdHl_K-OlV0zmASWdDkV_5smHN9_5d3V)

| Filename | Description | Source | Documentation | Columns | Rows | Size |
|:---------|:------------|:-------|:--------------|--------:|-----:|-----:|
| **`PHL_adm1.*`** | Province-level geographic boundaries shapefile | [`GADM`](http://gadm.org/country) | [`Documentation`](http://gadm.org/country) | 12 columns | 81 rows |  |

### Parsed data files

| Data file | Description | Columns | Rows | Input data | Processing script |
|:--|:--|--:|--:|:--|:--|
| `data00_shp_ncr.rds` | NCR boundaries | 12 columns | 1 row | `PHL_adm1.*` | `script00_raw ingest.R` |

## Datasets

### `Lorem.ipsum`

#### Schema

* **Lorem**
* **ipsum**

#### Sample