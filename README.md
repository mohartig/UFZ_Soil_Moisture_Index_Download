This repository contains data, scripts, and graphical outputs for the UFZ Soil Moisture Index (SMI) project. The SMI is designed to monitor soil moisture levels across different geographical regions and times, providing essential insights for agricultural, hydrological, and climate research.

Folder Structure:

    UFZ_Dürreindex_Master.R: The main R script for analyzing soil moisture index data.
    UFZ_Website.url: A URL shortcut to the project's website for more information: https://www.ufz.de/index.php?de=37937

01_R_Objects

Contains R scripts and data objects used for loading and processing geographical data (NUTS - Nomenclature of Territorial Units for Statistics).

    01_load_NUTS.R: Script to load NUTS data.
    02_next_year_function.R: Function script to process data for the next year.
    03_download_NUTS.R: Script to download NUTS data.
    EEA_crs.rda: Coordinate Reference System data.
    01_NUTS: Folder with NUTS data for different years (2003, 2006, 2010, 2013, 2016, 2021), each containing NUTS1, NUTS2, and NUTS3 levels.

02_Data

Contains the soil moisture index (SMI) data files in various formats.

    SMI_Gesamtboden_monatlich.nc: NetCDF file with monthly soil moisture data for the entire soil column.
    UFZ_SMI_[Year].Rds: Annual R data files for the soil moisture index from 1951 to recent years.

03_Graphics

Contains graphical representations of the Soil Moisture Index for various years.

    UFZ_SMI_[Year].png: Annual PNG files depicting the soil moisture index from the earliest available data to the most recent year.

Data Description

The project utilizes a range of data to calculate the Soil Moisture Index:

    NUTS Data: Geographical data delineating different European regions at various administrative levels (NUTS1, NUTS2, NUTS3) for specific years.
    Soil Moisture Data: Monthly and annual datasets representing soil moisture levels across different regions and times, stored in both NetCDF and R data formats.
    Graphical Outputs: Visual representations of the soil moisture index, illustrating changes and trends over time.

For detailed information on the methodology, data sources, and analysis, please refer to the UFZ_Dürreindex_Master.R script and the project's website: https://www.ufz.de/index.php?de=37937
