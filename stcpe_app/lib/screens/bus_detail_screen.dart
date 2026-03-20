import 'package:flutter/material.dart';
import '../models/bus_line.dart';
import '../data/mock_data.dart';
import '../widgets/stop_bottom_sheet.dart';
import '../widgets/stop_timeline_item.dart';

class BusDetailScreen extends StatefulWidget {
  final BusLine busLine;

  const BusDetailScreen({super.key, required this.busLine});

  @override
  State<BusDetailScreen> createState() => _BusDetailScreenState();
}

class _BusDetailScreenState extends State<BusDetailScreen> {
  bool _isForward = true;

  List<String> get _currentStops =>
      _isForward ? widget.busLine.stopsForward : widget.busLine.stopsReverse;

  String get _currentDirection =>
      _isForward ? widget.busLine.forwardLabel : widget.busLine.reverseLabel;

  void _toggleDirection() {
    setState(() => _isForward = !_isForward);
  }

  void _showStopDetails(String stopName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StopBottomSheet(
        busLine: widget.busLine,
        stopName: stopName,
        waitMinutes: MockData.getWaitTime(stopName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stops = _currentStops;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.busLine.color,
        title: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.busLine.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _currentDirection,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(230),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        itemCount: stops.length,
        itemBuilder: (_, i) {
          return StopTimelineItem(
            stopName: stops[i],
            lineColor: widget.busLine.color,
            isFirst: i == 0,
            isLast: i == stops.length - 1,
            waitMinutes: MockData.getWaitTime(stops[i]),
            onTap: () => _showStopDetails(stops[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleDirection,
        backgroundColor: widget.busLine.color,
        icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
        label: const Text(
          'Trocar Sentido',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
