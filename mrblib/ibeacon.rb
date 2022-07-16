# coding: utf-8

class IBeacon

  # 初期化
  def initialize()
    ibeacon_init
  end

  # RSSI
  def rssi()
    return ibeacon_rssi
  end

  # Distance
  def dist()
    return ibeacon_dist
  end

end
