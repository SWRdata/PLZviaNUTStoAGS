
#Unfertige VErsion!


library(readxl)
library(tidyverse)
library(httr)



# Datendownload -----------------------------------------------------------
#  Auf der Website https://ec.europa.eu/eurostat/de/web/nuts/local-administrative-units
# findet sich eine Excel-Datei für den Match von  NUTS-3-Codes zu AGS
#  https://ec.europa.eu/eurostat/documents/345175/501971/EU-28-LAU-2019-NUTS-2016.xlsx

url_nuts3_ags<-'https://ec.europa.eu/eurostat/documents/345175/501971/EU-28-LAU-2019-NUTS-2016.xlsx'

download.file(url_nuts3_ags, destfile = "EU-28-LAU-2019-NUTS-2016.xlsx", method = "curl")
nuts3_ags <- readxl::read_xlsx("EU-28-LAU-2019-NUTS-2016.xlsx", sheet = 8)

nuts3_ags <- nuts3_ags %>%  select(NUTS3 = 'NUTS 3 CODE', AGS = 'LAU CODE', NAME = 'LAU NAME NATIONAL')



#Auf https://ec.europa.eu/eurostat/de/web/nuts/correspondence-tables/postcodes-and-nuts
#findet sich der Link zu https://gisco-services.ec.europa.eu/tercet/flat-files: 
#auf der einen gezipte CSV für deutsche PLZ-Codes mit NUTS-3-Zuordnung zu finden ist: 
#https://gisco-services.ec.europa.eu/tercet/NUTS-2021/pc2020_DE_NUTS-2021_v3.0.zip

url_plz_zip <- 'https://gisco-services.ec.europa.eu/tercet/NUTS-2021/pc2020_DE_NUTS-2021_v3.0.zip'

download.file(url_plz_zip, destfile = "pc2020_DE_NUTS-2021_v3.0.zip", method = "curl")
plz_df <- read.csv2(unzip(zipfile ="pc2020_DE_NUTS-2021_v3.0.zip", files = "pc2020_DE_NUTS-2021_v3.0.csv" ), quote = "'", colClasses = "character")


#Erstelle eine Liste der 
df_plzags <- plz_df %>% select(NUTS3, PLZ = "CODE") %>% 
  inner_join(nuts3_ags, by = "NUTS3" )


