# coding: utf-8

class IBeacon

  # 初期化
  def initialize()
    ibeacon_init
  end

  # 取得
  def get()
    @info = ibeacon_info
    hash = {'Major'=> @info[0], 'Minor'=> @info[1], 'RSSI'=> @info[2], 'Dist'=> @info[3] / 1000.0 }  
    return hash
  end
  
  # Major
  def major()
    return @info[0]
  end

  # Minor
  def minor()
    return @info[1]
  end

  # RSSI
  def rssi()
    return @info[2]
  end

  # Distance
  def dist()
    return @info[3] / 1000.0
  end

end
