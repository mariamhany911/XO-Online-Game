import 'dart:async' as async;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/services/room_service.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final Timestamp turnStartAt;
  final String roomId;
  final bool xTurn;
  final List<String> board;
  final bool isMyTurn;
  const CountdownTimer({
    super.key,
    required this.turnStartAt,
    required this.board,
    required this.roomId,
    required this.xTurn,
    required this.isMyTurn,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  final RoomService _roomService = RoomService();

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.turnStartAt != widget.turnStartAt) {
      countdown(widget.turnStartAt);
    }
  }

  async.Timer? _timer;
  int remainingSeconds = 15;

  void countdown(Timestamp turnStartAt) {
    _timer?.cancel();

    _timer = async.Timer.periodic(Duration(seconds: 1), (timer) {
      final elapsed = Timestamp.now().seconds - turnStartAt.seconds;
      final remaining = 15 - elapsed;

      if (remaining > 0) {
        setState(() {
          remainingSeconds = remaining;
        });
      } else {
        setState(() {
          remainingSeconds = 0;
        });
        _timer?.cancel();
        if (widget.isMyTurn) {
          _roomService.updateGame(widget.roomId, !widget.xTurn, widget.board);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    countdown(widget.turnStartAt);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$remainingSeconds",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    );
  }
}
