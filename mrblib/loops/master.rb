# coding: utf-8

WiFi.init()
#WiFi.setup_ent_peap("id", "ssid", "username", "password")
WiFi.setup_psk("ssid", "key")
WiFi.start()

sleep 3

#I2C 初期化
i2c = I2C.new(0, 22, 21)
i2c.driver_install

# LCD 初期化
lcd = AQM0802A.new(i2c)
lcd.setup

# 時刻取得
SNTP.init()

# RTC 初期化. 時刻設定
rtc = RC8035SA.new(i2c)

#BCDコードへ変換. 
year = ((SNTP.year - 2000) / 10).to_i(2) << 4 | ((SNTP.year - 2000) % 10).to_i(2)
mon  = (SNTP.mon  / 10).to_i(2) << 4 | (SNTP.mon  % 10).to_i(2)
mday = (SNTP.mday / 10).to_i(2) << 4 | (SNTP.mday % 10).to_i(2)
hour = (SNTP.hour / 10).to_i(2) << 4 | (SNTP.hour % 10).to_i(2)
min  = (SNTP.min  / 10).to_i(2) << 4 | (SNTP.min  % 10).to_i(2)
sec  = (SNTP.sec  / 10).to_i(2) << 4 | (SNTP.sec  % 10).to_i(2)

#RTCに時刻を与える.
#rtc.write([0x20, 0x03, 0x31, 1, 0x23, 0x59, 0x50]) #年(下2桁), 月, 日, 曜日, 時, 分, 秒
rtc.write([year, mon, mday, SNTP.wday, hour, min, sec]) #年(下2桁), 月, 日, 曜日, 時, 分, 秒


sht = SHT75.new(2, 4)  # SHT75-CON2
sht.sht_init

while true
  temp = sht.sht_get_temp
  humi = sht.sht_get_humi(temp)
  puts "temperature: #{temp / 100.0}, humidity: #{humi}"
  
  tt = rtc.read
  lcd.cursor(0, 0)
  lcd.write_string(sprintf("%02x-%02x-%02x", tt[0], tt[1], tt[2]))
  lcd.cursor(0, 1)
  lcd.write_string(sprintf("%02x:%02x:%02x", tt[4], tt[5], tt[6]))
  sleep(2)

  lcd.cursor(0, 0)
  lcd.write_string(sprintf("t: %4.2f", temp/100.0))
  lcd.cursor(0, 1)
  lcd.write_string(sprintf("h: %4.2f", humi)) 
  sleep(3)
end
