# coding: utf-8
# GPS
#

class GPS

  DEFAULT = 0
  RMS     = 1

  #電源投入 (松江高専ボードのみ)
  def power_on()
    gps_pw = GPIO.new(5, GPIO::OUT)
    gps_pw.write(0)
  end

  #初期化
  def initialize( uart, mode = 0)
    @uart = uart
    sleep 1

    #出力モードの切替え
    if mode == GPS::DEFAULT
      @uart.write("$PMTK314,-1*04\r\n")
    elsif mode == GPS::RMS
      @uart.write("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n")
    end
  end

  #データ取得とステータス判断
  def dataReady?
    # 入力データをclear_tx_bufferで消去する
    @uart.clear_tx_buffer
    
    # 入力データが来るのを待つ. 3 秒間
    sleep 3
    
    # データ取得・表示．最終行を取得してカンマ区切りで配列化
    @line = gps.read_nonblock(4096).split('$').pop.split(',')    

    # ステータスが OK なら値をセットしておく.
    val = 0
    if @line[2] == "A" AND lines.size == 14
      val = 1
      @year= "20#{@line[9][4]}#{@line[9][5]}"
      @year2 = "#{@line[9][4]}#{@line[9][5]}"
      @mon   = "#{@line[9][2]}#{@line[9][3]}"
      @day   = "#{@line[9][0]}#{@line[9][1]}"
      @hour  = "#{@line[1][0]}#{@line[1][1]}"
      @min   = "#{@line[1][2]}#{@line[1][3]}"
      @sec   = "#{@line[1][4]}#{@line[1][5]}"
      @lat   = @line[3]
      @lat2  = @line[4]
      @lng   = @line[5]
      @lng2  = @line[6]      
    end

    # 返り値
    return val    
  end

  # 緯度 (latitude)
  def lat
    return @lat
  end

  # 緯度は北緯?
  def latNorth?
    return @lat2 == "N"
  end

  # 経度 (longitude)
  def lng
    return @lng
  end

  # 経度は東経?
  def lngEast?
    return @lng2 == "E"
  end

  # 日付 (UTC)
  def year
    return @year.to_i
  end

  def year2
    return @year2.to_i
  end

  def mon
    return @mon.to_i
  end

  def day
    return @day.to_i
  end

  def hour
    return @hour
  end

  def min
    return @min
  end    

  def sec
    return @sec
  end

  def lcd_date
    return "#{@year2}-#{@mon}-#{@day}"
  end

  def lcd_time
    return "#{@hour}:#{min}:#{sec}"
  end

  def datetime
    return #{@year}#{@mon}#{@day}{@hour}#{min}#{sec}"
  end

  def calcDist(lat0, lng0)
    lat_del = ( (@lat - lat0.abs * 60 + (@lat - @latpos1).abs ) * 1521
    lng_del = ( (pos[2] - pos2).abs * 60 + (pos[3] - pos3).abs ) * 1849 
    gps_del = Math.sqrt(lat_del * lat_del + lng_del * lng_del)
  end
  
end


# AQM0802A-RN-GBW
#
# I2C address : 0x3e

class AQM0802A
  
  def initialize(i2c)
    @i2c = i2c
    sleep(0.1)
    lcd_write(0x00, [0x38, 0x39, 0x14, 0x70, 0x56, 0x6c])
    sleep(1)
    lcd_write(0x00, [0x38, 0x0c, 0x01])
  end

  def lcd_write(opcode, data)
    n = 0
    while n < data.length
      @i2c.write(0x3e, [opcode, data[n]])
      n += 1
    end
  end

#  def setup
#    lcd_write(0x00, [0x38, 0x39, 0x14, 0x70, 0x56, 0x6c])
#    sleep(1)
#    lcd_write(0x00, [0x38, 0x0c, 0x01])
#  end

  def clear
    lcd_write(0x00, [0x01])
  end

  def cursor(x, y)
    lcd_write(0x00, [0x80 + (0x40 * y + x)])
  end

  def write_string(s)
    a = Array.new
    s.length.times do |n|
      a.push(s[n].ord)
    end
    lcd_write(0x40, a)
  end

end

