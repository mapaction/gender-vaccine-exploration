library(ggplot2)
library(dplyr)
library(sf)
library(readxl)
library(tmap)
library(rnaturalearth)
library(sp)

data <- read_excel('EDITED-COVID-19-Gender-Vulnerability-Data-Dashboard-by-ODW.xlsx', sheet=2)
colnames(data) = data[2, ]
data = data[-1:-2, ]
cols_num <- c(5:29)
data[cols_num] <- sapply(data[cols_num],as.numeric)
colnames(data) <- c('ISO', 
                    'UN_CODE', 
                    'NAME', 
                    'INC_GR', 
                    'GNI', 
                    'GDP_GR_1519', 
                    'GDP_GR_20', 
                    'GDP_GR_21', 
                    'POP_19', 
                    'NW_CSS_31', 
                    'NW_CSS_61', 
                    'DIU', 
                    'NW_D_31', 
                    'NW_D_61',
                    'FM_CSS',
                    'FM_D',
                    'I_WH',
                    'D_WH',
                    'I_EW',
                    'D_EW',
                    'I_HC',
                    'D_HC',
                    'I_C',
                    'D_C',
                    'NA',
                    'I_VULN',
                    'D_VULN',
                    'HI_CSS',
                    'S_ES')

# Read in the OCHA data on vaccine delivery
data_cases <- read.csv('ocha-doses.csv')
data_cases <- data_cases[-1,]
cols_num <- c(4:12)
data_cases[cols_num] <- sapply(data_cases[cols_num],as.numeric)
# Read in the basic country outlines
countries <- ne_countries(returnclass = 'sf')


# Basic choropleth maps ---------------------------------------------------

# Palettes
# YlOrBr
# RdPu
# YlGnBu


df_index <- countries %>%
  full_join(data, by=c('iso_a3'='ISO'))%>%
  full_join(data_cases, by=c('iso_a3' = 'ISO3'))

m <- tm_shape(df_index) +
  tm_layout(frame=FALSE) +
  tm_fill(col='Total.Delivered',
          title='Total vaccines\ndelivered',
          legend.hist = TRUE,
          palette='Greens',
          colorNA='#ededed')+
  tm_borders(col='#ededed',lwd=0.1)
m

tmap_save(m, 'tot-delv.png')
