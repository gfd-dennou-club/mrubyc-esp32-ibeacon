# coding: utf-8
# GPS
#

class GPS

  DEFAULTmode = 0
  RMSmode     = 1

  #電源ON (松江高専ボードのみ)
  def power_on()
    gps_pw = GPIO.new(5, GPIO::OUT)
    gps_pw.write(0)
  end

  #電源OFF (松江高専ボードのみ)
  def power_off()
    gps_pw = GPIO.new(5, GPIO::OUT)
    gps_pw.write(1)
  end

  #初期化
  def initialize( uart, mode = 0)
    @uart = uart
    sleep 1

    #出力モードの切替え
    if mode == GPS::DEFAULTmode
      @uart.write("$PMTK314,-1*04\r\n")
    elsif mode == GPS::RMSmode
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
    @line = (@uart.read_nonblock(4096).split('$').pop).split(',')

    # ステータスが OK なら値をセットしておく.
    # if @line[2] == "A" AND @line[13].size == 14
    p @line
    if @line[2] == "A"
      @year= "20#{@line[9][4]}#{@line[9][5]}"
      @year2 = "#{@line[9][4]}#{@line[9][5]}"
      @mon   = "#{@line[9][2]}#{@line[9][3]}"
      @day   = "#{@line[9][0]}#{@line[9][1]}"
      @hour  = "#{@line[1][0]}#{@line[1][1]}"
      @min   = "#{@line[1][2]}#{@line[1][3]}"
      @sec   = "#{@line[1][4]}#{@line[1][5]}"

      @lat   = @line[3]
      @latDeg  = "#{@lat[0]}#{@lat[1]}".to_f
      @latMin  = "#{@lat[2]}#{@lat[3]}#{@lat[4]}#{@lat[5]}#{@lat[6]}#{@lat[7]}#{@lat[8]}}".to_f

      @lng   = @line[5]
      @lngDeg  = "#{@lng[0]}#{@lng[1]}#{@lng[2]}".to_f 
      @lngMin  = "#{@lng[3]}#{@lng[4]}#{@lng[5]}#{@lng[6]}#{@lng[7]}#{@lng[8]}#{@lng[9]}}".to_f

      @latSign = @line[4]
      @lngSign = @line[6]

      return true
    else

      # 返り値
      return false
    end
  end
  
  # 緯度 (latitude)．文字列を返す．フォーマット: dddmm.mmmm 
  def lat
    return @lat
  end

  # 緯度 (latitude)．数字の配列を返す
  def latDegMin
    return [@latDeg, @latMin]
  end
  
  # 緯度は北緯?
  def latNorth?
    return @latSign == "N"
  end

  # 経度 (longitude)．文字列を返す．フォーマット: dddmm.mmmm 
  def lng
    return @lng
  end

  # 経度 (longitude)．数字の配列を返す
  def lngDegMin
    return [@lngDeg, @lngMin]
  end  

  # 経度は東経?
  def lngEast?
    return @lngSign == "E"
  end

  #緯度経度
  def DegMin
    return [@latDeg, @latMin, @lngDeg, @lngMin]
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
    return @hour.to_i
  end

  def min
    return @min.to_i
  end    

  def sec
    return @sec.to_i
  end

  def datetime
    return [@year2.to_i, @mon.to_i, @day.to_i, @hour.to_i, @min.to_i, @sec.to_i]
  end  

  def str_date
    return "#{@year2}-#{@mon}-#{@day}"
  end

  def str_time
    return "#{@hour}:#{min}:#{sec}"
  end
  
  def str_datetime
    return "#{@year}#{@mon}#{@day}#{@hour}#{min}#{sec}"
  end

  
end
