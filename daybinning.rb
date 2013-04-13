require 'csv'
require 'activesupport'


CSV_FILE = "incident.csv"
csvfile = CSV.read(CSV_FILE, :headers => true)
csvfile.each do |inc|
  inc["start_date"] = Date.strptime(inc["opened_at"], "%Y-%m-%d %H:%M:%S")
  inc["end_date"] = Date.strptime(inc["u_resolved"], "%Y-%m-%d %H:%M:%S") unless inc["u_resolved"].blank?
end

#Find min and max dates from the ranges
  minenddate = csvfile["end_date"].each.reject{|x| x.nil?}.min
  minstartdate = csvfile["start_date"].each.reject{|x| x.nil?}.min
  mindate = [minenddate, minstartdate].min

  maxenddate = csvfile["end_date"].each.reject{|x| x.nil?}.max
  maxstartdate = csvfile["start_date"].each.reject{|x| x.nil?}.max
  maxdate = [maxenddate, maxstartdate].max
  #don't include today, data is incomplete
  maxdate = maxdate - 1.day if maxdate == Date.today




#For the range of dates in the csvfile, figure out how many tickets opened per day
CSV.open("incidentsopened.csv", "w") do |csvoutput|
  csvoutput << ["date", "value"]
  (mindate..maxdate).each do |date|
    count = csvfile["start_date"].count { |d| d == date}
    csvoutput << [date.to_s, count.to_s]
  end
end

#For the range of dates in the csvfile, figure out how many tickets resolved per day
CSV.open("incidentsresolved.csv", "w") do |csvoutput|
  csvoutput << ["date", "value"]
  (mindate..maxdate).each do |date|
    count = csvfile["end_date"].count { |d| d == date }
    csvoutput << [date.to_s, count.to_s]
  end
end

#For the range of dates in the csvfile, figure out how many tickets we had open each day
CSV.open("incidentsactive.csv", "w") do |csvoutput|
  csvoutput << ["date", "value"]
  (mindate..maxdate).each do |date|
    count = 0
    csvfile.each do |row|
      #add one if the incident was open on this date
      if row["end_date"].nil? & (row["start_date"] <= date)
        #if it's still open, it counts
        count = count + 1000
      elsif row["end_date"].nil?
        #if it wasn't opened yet at the time, it doesn't count
      elsif (row["end_date"] >= date) & (row["start_date"] <= date)
        #if it was beween these bounds, it counts
        count = count + 1
      end
    end
    csvoutput << [date.to_s, count.to_s]
  end
end
