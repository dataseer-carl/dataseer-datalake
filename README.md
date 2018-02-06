# DataLake
> Curated datasets for content development

Poject desription and objectives.

### Current Data Sources

Under contruction.

### Usage

#### Ingestion

Workflow: GDrive and GitHub &rarr; Clone repo to desktop &rarr; stage in GDrive, push and merge in GitHub

See [Trello](https://trello.com/c/gRCvHb0Z).

#### Scenario prep

Under construction.

### Stages

#### Data Stage

Data file hosting.

`dump://` is located in `~/Data/DataLake` in [GDrive](https://drive.google.com/drive/folders/1IQXPXMZSEK4QK_gKK2ERp9pOs4wJ_dog?usp=sharing).  

Currently hosted in Carl Calub's GDrive.

#### Repo

Jobs scripts and data documentation.

`repo://` refers to the [GitHub repository](https://github.com/dataseer-carl/dataseer-datalake)

All `Data/` sub-directories are git-ignored.

#### Wiki

Portal for scenarios.

### Definitions

* **Data source** is a dataset or a collection thereof that capture one specific scenario
* **Author** is the publisher of the data source
* **Data files** are the files in the data source that contain the dataset(s).  Unaltered data files are called *raw data*; while raw data files that have been loaded and cleaned are called *parsed data*
* **Datasets** are the tables represented by the data files.  When a raw data file is loaded, a new data file is created but said artifact should contain the same dataset.