import 'package:flutter_blue/flutter_blue.dart';

class PeripheralServices {
  static final Guid SERVICE_DEVICE_INFORMATION =
      Guid("0000180a-0000-1000-8000-00805f9b34fb");
  //
  static final Guid SERVICE_HEART_RATE =
      Guid("0000180d-0000-1000-8000-00805f9b34fb");
}

class PeripheralCharacteristics {
  static final Guid HEART_RATE_MEASUREMENT =
      Guid("00002a37-0000-1000-8000-00805f9b34fb");

  static final Guid BATTERY_INFORMATION =
      Guid("00000007-0000-3512-2118-0009af100700");
}

// 180A: Device Information
// 1811: Alert
// 1802: Immediate Alert
// 180D: Heart Rate
// fee0: Anhui Huami Information Technology Co., Ltd.
// 180F: Battery
