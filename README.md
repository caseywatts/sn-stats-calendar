sn-stats-calendar
=================

This repo has two parts

##Data-parsing script
Ruby script which parses a csv export from Service Now into one-day
bins. Requires Ruby.

1. Download a list report from Service Now with the columns "Opened" and "Resolved". Export as csv, saved with the name "incident.csv"
2. Put the csv in the same folder as `daybinning.rb`
3. Run `ruby daybinning.rb`
4. It produces two csv files, `incidentsopened.csv` and
   `incidentsresolved.csv`

##Pata-plotting html/css/js
Source code was taken from d3js.org

1. Results can be visualized by opening `incidentsopened.html` or
   `incidentsresolved.csv`
2. Links are hard-coded in the HTML, but can be modified to fit the
   needs.
