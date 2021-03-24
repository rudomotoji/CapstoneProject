import 'dart:math';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/peripheral/blocs/peripheral_bloc.dart';
import 'package:capstone_home_doctor/features/peripheral/events/peripheral_event.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repo.dart';
import 'package:capstone_home_doctor/features/peripheral/states/peripheral_state.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//
final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(10.0, 1.0, 100.0, 20.0));

final PeripheralHelper _peripheralHelper = PeripheralHelper();

// final PeripheralServices _peripheralServices = PeripheralServices();
// final PeripheralCharacteristics _peripheralCharacteristics = PeripheralCharacteristics();

class PeripheralService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PeripheralService();
  }
}

class _PeripheralService extends State<PeripheralService>
    with WidgetsBindingObserver {
  //
  PeripheralBloc _peripheralBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _peripheralBloc = BlocProvider.of(context);
    _getPeripheralId();
    // const oneSec = const Duration(minutes: 1);
    // new Timer.periodic(oneSec, (Timer t) => hrBloc.updateHR(tmpHR));
  }

  _getPeripheralId() async {
    await _peripheralHelper.getPeripheralId().then((value) {
      if (value != '') {
        _peripheralBloc.add(PeripheralEventFindById(id: value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(
              title: 'Chi tiết thiết bị',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: ListView(
                children: [
                  //
                  BlocBuilder<PeripheralBloc, PeripheralState>(
                    builder: (context, state) {
                      if (state is PeripheralStateLoading) {
                        //
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width - 40,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset('assets/images/loading.gif'),
                          ),
                        );
                      }
                      if (state is PeripheralStateFailure) {
                        return Container(
                          child: Text('Chưa có thiết bị kết nối'),
                        );
                      }
                      if (state is PeripheralStateFindByIdSuccess) {
                        if (state.device != null) {
                          print('state device name is ${state.device}');
                          return Container(
                            child: Text('${state.device.name}'),
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: true);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
