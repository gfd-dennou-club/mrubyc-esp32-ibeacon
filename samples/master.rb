
ibeacon = IBeacon.new 

led13 = GPIO.new( 13, GPIO::OUT )
led12 = GPIO.new( 12, GPIO::OUT )
led14 = GPIO.new( 14, GPIO::OUT )
led27 = GPIO.new( 27, GPIO::OUT )
led26 = GPIO.new( 26, GPIO::OUT )
led25 = GPIO.new( 25, GPIO::OUT )
led33 = GPIO.new( 33, GPIO::OUT )
led32 = GPIO.new( 32, GPIO::OUT )

i2c = I2C.new(22, 21)
lcd = AQM0802A.new(i2c)

sw34 = GPIO.new( 34, GPIO::IN, GPIO::PULL_UP)
sw35 = GPIO.new( 35, GPIO::IN, GPIO::PULL_UP)
sw18 = GPIO.new( 18, GPIO::IN, GPIO::PULL_UP)
sw19 = GPIO.new( 19, GPIO::IN, GPIO::PULL_UP)

pwm1 = PWM.new( 15 )

while true do
  ibeacon.get
  if ibeacon.major == 11111
    if ibeacon.dist < 10
      led13.write(1)
      led12.write(0)
      led14.write(1)
      led27.write(0)
      led26.write(1)
      led25.write(0)
      led33.write(1)
      led32.write(1)
      lcd.cursor(0, 0)
      lcd.write_string("        ")
      lcd.cursor(0, 0)
      lcd.write_string((ibeacon.minor).to_s)
      lcd.cursor(0, 1)
      lcd.write_string("        ")
      lcd.cursor(0, 1)
      lcd.write_string((ibeacon.dist).to_s)
      if ibeacon.dist < 1
        led13.write(1)
        led12.write(1)
        led14.write(1)
        led27.write(1)
        led26.write(1)
        led25.write(1)
        led33.write(1)
        led32.write(1)
        if (sw34.read == 0) && (sw35.read == 0) && (sw18.read == 0) && (sw19.read == 1)
          pwm1.freq(261)
          pwm1.duty(512)
        end
      end
    end
    sleep(1)
  end
  led13.write(0)
  led12.write(0)
  led14.write(0)
  led27.write(0)
  led26.write(0)
  led25.write(0)
  led33.write(0)
  led32.write(0)
  pwm1.duty(0)
  sleep(0.05)
end
