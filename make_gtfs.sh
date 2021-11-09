#!/bin/bash

set -ev

wget "https://app.interline.io/osm_extracts/download_latest?string_id=kochi_india&data_format=pbf&api_token=$INTERLINE_EXTRACTS_API_KEY" --no-verbose --output-document=data.osm.pbf 2>&1

osmium tags-filter data.osm.pbf type=route_master type=route -o pt_data.osm.pbf

mkdir output

cd prism

poetry run python prism/cli.py ../pt_data.osm.pbf --outdir ../output/ --loglevel=WARNING --config ../conf.json -gtfs -csv

cd ..

./gtfsvtor/bin/gtfsvtor output/output_gtfs.zip

cp validation-results.html ./output/validation-results.html

cd output

unzip output_gtfs.zip

unzip as_csv.zip

cat lines.csv |xsv select 1-7 > lines_for_unroll.csv

xsv join route_id line_routes.csv route_id route_stops.csv |xsv select '!route_id[1]' > temp_line_route_stop.csv

xsv join stop_point_id temp_line_route_stop.csv stop_point_id stop_points.csv |xsv select line_id,route_id,stop_point_id,name,latitude,longitude > full_stops_list.csv

cat full_stops_list.csv |xsv select line_id,name |xsv search -s name '^$' -v |xsv sort -s line_id,name |uniq > stops_list.csv

rm temp_*

cd ..
