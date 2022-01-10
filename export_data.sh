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

xsv join stop_point_id temp_line_route_stop.csv stop_point_id stop_points.csv |xsv select line_id,route_id,stop_point_id,stop_point_index,name | xsv search -s name '^$' -v |xsv sort -s line_id,route_id,stop_point_index > full_stops_list.csv

xsv join line_id line_routes.csv line_id lines.csv |xsv select line_id,route_id,name > temp_line_routes.csv

xsv join route_id temp_line_routes.csv route_id routes.csv |xsv select 1-3,5 > temp_lines_and_routes.csv

echo "line_id,route_id,line_name,route_name" > line_routes_names.csv
tail -n +2 temp_lines_and_routes.csv >> line_routes_names.csv 

rm temp_*

cd ../bifidus_cli

poetry run python bifidus_cli.py -l ../output/lines.csv -r ../output/routes.csv -u ../bifidus_config.csv -n KochiTransport > ../output/qa.md

poetry run python ../directions.py 

