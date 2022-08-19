
ibeacon = IBeacon.new 
while true do
  ibeacon.get
#  if ibeacon.major == 11111
#    puts "minor : #{ibeacon.minor}"
#    puts "#{ibeacon.dist} m"
#  end

  puts "major : #{ibeacon.major}"
  puts "minor : #{ibeacon.minor}"
  puts "#{ibeacon.dist} m"

  sleep(0.05)
end
