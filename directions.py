#!/usr/bin/env python
# coding: utf-8

import csv

to_export = []
with open('../output/line_routes_names.csv', 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file, delimiter=',')
    for row in csv_reader:
        line_split = row['line_name'].split(' ↔ ')
        route_split = row['route_name'].split(' → ')
        if line_split[0] == route_split[0] and line_split[-1] == route_split[-1]:
            row["direction"] = "forward"
        elif line_split[0] == route_split[-1] and line_split[-1] == route_split[0]:
            row["direction"] = "backward"
        else:
            row["direction"] = "unknown"
        to_export.append(row)     

with open('../output/directions.csv', 'w') as out_file:
    csv_writer = csv.DictWriter(out_file, delimiter=',', fieldnames=to_export[0].keys())
    csv_writer.writeheader()
    for row in to_export:
        csv_writer.writerow(row)   

