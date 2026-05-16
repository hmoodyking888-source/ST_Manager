import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../theme/app_theme.dart';

class SpeedGauge extends StatelessWidget {
  final double speedMbps;

  const SpeedGauge({super.key, required this.speedMbps});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 180,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 100,
              axisLineStyle: const AxisLineStyle(
                thickness: 0.15,
                thicknessUnit: GaugeSizeUnit.factor,
                color: Colors.grey,
              ),
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: speedMbps.clamp(0, 100),
                  needleColor: AppTheme.gold,
                  knobStyle: const KnobStyle(color: AppTheme.gold),
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${speedMbps.toStringAsFixed(1)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Mbps',
                        style: TextStyle(color: AppTheme.gold, fontSize: 12),
                      ),
                    ],
                  ),
                  angle: 90,
                  positionFactor: 0.7,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
