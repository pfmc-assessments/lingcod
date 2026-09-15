# CSV file with EEZ created by Ian from KML file available from
# http://www.nauticalcharts.noaa.gov/csdl/mbound.htm#data
eez <- read.csv('data-raw/EEZ_polygon_lat_lon.csv')

usethis::use_data(eez)
