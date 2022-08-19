# coding: utf-8
##############################################################
#
# 工作教室：iBeacon 課題
#
##############################################################
# Minor の番号を全て集めると，暗号が解ける
# 数字暗号：https://cotobasearch.com/encrypt/number

#I2C 初期化
i2c = I2C.new(22, 21)

# LCD 初期化
lcd = AQM0802A.new(i2c)

# スイッチ初期化
sw34 = GPIO.new( 34, GPIO::IN, GPIO::PULL_UP)
sw35 = GPIO.new( 35, GPIO::IN, GPIO::PULL_UP)
sw18 = GPIO.new( 18, GPIO::IN, GPIO::PULL_UP)
sw19 = GPIO.new( 19, GPIO::IN, GPIO::PULL_UP)

# LED 初期化
led13 = GPIO.new( 13, GPIO::OUT )
led12 = GPIO.new( 12, GPIO::OUT )
led14 = GPIO.new( 14, GPIO::OUT )
led27 = GPIO.new( 27, GPIO::OUT )
led26 = GPIO.new( 26, GPIO::OUT )
led25 = GPIO.new( 25, GPIO::OUT )
led33 = GPIO.new( 33, GPIO::OUT )
led32 = GPIO.new( 32, GPIO::OUT )

# PWM 有効化
pwm15 = PWM.new( 15 )

# iBeacon 初期化
ibeacon = IBeacon.new

loop do
  info = ibeacon.get
#  puts "*** Major: #{ibeacon.major}   #{info['Major']}"
#  puts "*** Minor: #{ibeacon.minor}   #{info['Minor']}"
#  puts "*** RSSI:  #{ibeacon.rssi}    #{info['RSSI']}"
#  puts "*** Dist: #{ibeacon.dist} m   #{info['Dist']} m"
  if ibeacon.major == 11111
    # 10 m を切っていれば LCD 表示. LED 4 つ点灯
    if ibeacon.dist < 10.0
      lcd.clear
      lcd.cursor(0, 0)
      lcd.write_string( ibeacon.minor.to_s )
      lcd.cursor(0, 1)
      lcd.write_string( ibeacon.dist.to_s )
      
      led13.on
      led14.on
      led12.on
      led27.on
      
      # 1m を切っていれば LED, ブザー
      if ibeacon.dist < 1.0
        if sw19.read == 1
          p "PWM ON"
        pwm15.freq( 440 )
        pwm15.duty(512)
        else
          p "PWM OFF"
        pwm15.freq( 440 )
        pwm15.duty(0)
        end
        led26.on
        led25.on
        led33.on
        led32.on
      end      
    end
    sleep 1
  end
  sleep 0.05
  
  # 消灯
  led13.off
  led14.off
  led12.off
  led27.off
  led26.off
  led25.off
  led33.off
  led32.off            
  
end

