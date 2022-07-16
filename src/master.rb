# coding: utf-8

# GPSの電源を入れる (高専ボードの場合に必要)
GPS.power_on

#UART 初期化
uart = UART.new(2, 9600)

# GPS 初期化
gps = GPS.new(uart, GPS::RMS)

while true
  if gps.dataReady?
    p gps.lng
    p gps.lng2
    p gps.lat
    p gps.lat2
    p gps.str_date
    p gps.str_time
    p gps.str_datetime
    p gps.datetime
  else
    puts "wait...."    
  end
end


=begin
ibeacon = IBeacon.new

loop do
  puts "rssi: #{ibeacon.rssi}"
  puts "Dist: #{ibeacon.dist} m"
  sleep 2
end
=end

=begin
#I2C 初期化
i2c = I2C.new(22, 21)

# CO2センサ初期化
scd30 = SCD30.new(i2c)

# 観測
loop do
  if scd30.dataReady
    var = scd30.read
    if var
      puts "CO2         : #{var[0]} ppm"
      puts "Temperature : #{var[1]} C"
      puts "Humidity    : #{var[2]} %"
    end
  end
  
  sleep( 0.5 )
end
=end

=begin
#I2C 初期化
i2c = I2C.new(22, 21)

# RTC 初期化. 時刻設定
rtc = RX8035SA.new(i2c)

# LCD 初期化
lcd = AQM0802A.new(i2c)

# Wi-Fi 初期化
wlan = WLAN.new('STA', WLAN::ACTIVE)

# WiFiの接続
puts 'start connect....'
wlan.connect("SugiyamaLab", "epi.it.matsue-ct.jp")

# 時刻合わせ
puts 'start SNTP...'
sntp = SNTP.new
p sntp.str_date, sntp.str_time, sntp.str_datetime, sntp.datetime

# 書き込み. 年(下2桁), 月, 日, 曜日, 時, 分, 秒
rtc.write( sntp.datetime )

# LCD に "Hello World" 表示
lcd.cursor(1, 0)
lcd.write_string("Hello!")
lcd.cursor(0, 1)
lcd.write_string("from ESP")
sleep(10)

while true
  
  # 時刻取得
  tt = rtc.read
  p rtc.read
  p rtc.datetime
  
  # 時刻表示
  lcd.cursor(0, 0)
  lcd.write_string( rtc.str_date )
  lcd.cursor(0, 1)
  lcd.write_string( rtc.str_time )
  
  p rtc.str_date, rtc.str_time, rtc.str_datetime
  
  # 待ち時間
  sleep 0.5
end
=end

=begin
#I2C 初期化
i2c = I2C.new(22, 21)

# RTC 初期化. 時刻設定
rtc = RX8035SA.new(i2c)
rtc.write([20, 3, 31, 1, 23, 59, 50]) #年(下2桁), 月, 日, 曜日, 時, 分, 秒

while true
  tt = rtc.read
  puts sprintf("%02d-%02d-%02d", tt[0], tt[1], tt[2])
  puts sprintf("%02d:%02d:%02d", tt[4], tt[5], tt[6])
  puts ""
  sleep 1.0
end
=end

=begin
#I2C 初期化
i2c = I2C.new(22, 21)

# LCD 初期化
lcd = AQM0802A.new(i2c)

# RTC 初期化. 時刻設定
rtc = RX8035SA.new(i2c)
rtc.write([20, 03, 31, 1, 23, 59, 50]) #年(下2桁), 月, 日, 曜日, 時, 分, 秒

# LCD に "Hello World" 表示
lcd.cursor(1, 0)           #カーソル位置を 0 行目の 1 文字目に
lcd.write_string("Hello!")

# i2c で直接送信
lcd.cursor(0, 1)           #カーソル位置を 1 行目の 0 文字目に
lcd.write_string("from ESP")

# Hello World 表示を行う
sleep(10)

while true
  tt = rtc.read
  
  puts sprintf("%02d-%02d-%02d", tt[0], tt[1], tt[2]) 
  puts sprintf("%02d:%02d:%02d", tt[4], tt[5], tt[6])
  puts ""
  
  lcd.clear
  lcd.cursor(0, 0)           #カーソル位置を 0 行目の 1 文字目に
  lcd.write_string( sprintf("%02d-%02d-%02d", tt[0], tt[1], tt[2]) )
  lcd.cursor(0, 1)           #カーソル位置を 1 行目の 0 文字目に
  lcd.write_string( sprintf("%02d:%02d:%02d", tt[4], tt[5], tt[6]) )

  sleep 1.0
end
=end
