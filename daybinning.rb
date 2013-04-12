require 'csv'
require 'activesupport'


CSV_FILE = "incident.csv"
csvfile = CSV.read(CSV_FILE, :headers => true)
csvfile.each do |inc|
  inc["start_date"] = Date.strptime(inc["opened_at"], "%Y-%m-%d %H:%M:%S")
  inc["end_date"] = Date.strptime(inc["u_resolved"], "%Y-%m-%d %H:%M:%S")
end

#For the range of dates in the csvfile, figure out how many tickets opened per day
CSV.open("incidentsopened.csv", "w") do |csvoutput|
  csvoutput << ["date", "value"]
  (csvfile["start_date"].min..csvfile["start_date"].max).each do |date|
    count = csvfile["start_date"].count { |d| d == date}
    csvoutput << [date.to_s, count.to_s]
  end
end

#For the range of dates in the csvfile, figure out how many tickets resolved per day
CSV.open("incidentsresolved.csv", "w") do |csvoutput|
  csvoutput << ["date", "value"]
  (csvfile["end_date"].min..csvfile["end_date"].max).each do |date|
    count = csvfile["end_date"].count { |d| d == date}
    csvoutput << [date.to_s, count.to_s]
  end
end

#For the range of dates in the csvfile, figure out how many tickets we had open each day
CSV.open("incidentsactive.csv", "w") do |csvoutput|
  csvoutput << ["date", "value"]
  (csvfile["end_date"].min..csvfile["end_date"].max).each do |date|
    count = csvfile["end_date"].count { |d| d == date}
    csvoutput << [date.to_s, count.to_s]
  end
end
