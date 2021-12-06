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

  static final Guid HEART_RATE_CONTROL_POINT =
      Guid("00002a39-0000-1000-8000-00805f9b34fb");

  static final Guid ACTIVITY = Guid("00000007-0000-3512-2118-0009af100700");

  static final Guid BATTERY_INFORMATION =
      Guid("00000006-0000-3512-2118-0009AF100700");
}

// 180A: Device Information
// 1811: Alert
// 1802: Immediate Alert
// 180D: Heart Rate
// fee0: Anhui Huami Information Technology Co., Ltd.
// 180F: Battery

class PeripheralCommand {
///////HEART RATE READING MODE
  static final SLEEP = 0x0;
  static final CONTINUOUS = 0x1;
  static final MANUAL = 0x2;

///////TOGGLE
  static final TOGGLE_OFF = 0x0;
  static final TOGGLE_ON = 0x1;

////////DEVICE EVENT
  static final BUTTON_PRESSED = 0x4;

////////COMMAND
  static final START_HEART_RATE_MORNITORING = [0x15, CONTINUOUS, TOGGLE_ON];
  static final STOP_HEART_RATE_MORNITORING = [0x15, CONTINUOUS, TOGGLE_OFF];
  static final START_HEART_RATE_MEASUREMENT = [0x15, MANUAL, TOGGLE_ON];
  static final STOP_HEART_RATE_MEASUREMENT = [0x15, CONTINUOUS, TOGGLE_OFF];
}

///logic: use 2a39 to start heart rate control point -> use 2a37 to listen value.
