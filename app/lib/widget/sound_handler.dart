import 'package:flutter/material.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import '../../../theme.dart';

class SoundHandler extends StatefulWidget {
  const SoundHandler({super.key});

  @override
  State<SoundHandler> createState() => _HomeState();
}

class _HomeState extends State<SoundHandler> {
  double currentvol = 0.5;

  @override
  void initState() {
    PerfectVolumeControl.hideUI =
        false; //set if system UI is hided or not on volume up/down
    Future.delayed(Duration.zero, () async {
      currentvol = await PerfectVolumeControl.getVolume();
      setState(() {
        //refresh UI
      });
    });

    PerfectVolumeControl.stream.listen((volume) {
      setState(() {
        currentvol = volume;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            const Icon(Icons.volume_off, color: BlackTertiary),
            Slider(
              value: currentvol,
              onChanged: (newvol) {
                currentvol = newvol;
                PerfectVolumeControl.setVolume(newvol); //set new volume
                setState(() {});
              },
              min: 0, //
              max: 1,
              divisions: 100,
            ),
            const Icon(
              Icons.volume_up_rounded,
              color: BlackTertiary,
            )
          ],
        ));
  }
}
