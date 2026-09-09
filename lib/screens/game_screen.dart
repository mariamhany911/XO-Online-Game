import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/constants/colors.dart';
import 'package:final_project/models/room.dart';
import 'package:final_project/models/room_state_enum.dart';
import 'package:final_project/routes/route_name.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:final_project/services/player_service.dart';
import 'package:final_project/services/room_service.dart';
import 'package:flutter/material.dart';
import 'dart:async' as async;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final RoomService _roomService = RoomService();
  final AuthService _authService = AuthService();
  final PlayerService _playerService = PlayerService();

  Future<void> move(int index, Room room) async {
    final creator = _authService.getUid() == room.creatorId;
    final tempBoard = List<String>.from(room.board);

    if (room.roomState != RoomState.playing) {
      return;
    }
    if (room.board[index] == "") {
      if (creator && room.xTurn) {
        tempBoard[index] = "X";
        await _roomService.updateGame(room.roomId!, false, tempBoard);
      } else if (!creator && !room.xTurn) {
        tempBoard[index] = "O";
        await _roomService.updateGame(room.roomId!, true, tempBoard);
      } else {
        return;
      }
    } else {
      return;
    }

    String? winner = checkWinner(tempBoard);

    if (winner != null) {
      if (winner == "X") {
        winner = room.creatorId;
        await _roomService.updateWinner(room.roomId!, winner);
        await _roomService.updateRoomState(room.roomId!, RoomState.finished);
      } else if (winner == "O") {
        winner = room.opponentId;
        await _roomService.updateWinner(room.roomId!, winner!);
        await _roomService.updateRoomState(room.roomId!, RoomState.finished);
      }
    } else if (winner == null && !tempBoard.contains("")) {
      await _roomService.updateRoomState(room.roomId!, RoomState.finished);
    }
  }

  String? checkWinner(List<String> board) {
    const winningOptions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (final option in winningOptions) {
      final a = option[0];
      final b = option[1];
      final c = option[2];
      if (board[a] != '' && board[a] == board[b] && board[b] == board[c]) {
        return board[a];
      }
    }
    return null;
  }

  bool _dialogShown = false;
  void showResultDialog(Room room) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: room.winnerId == null
              ? Text("Draw game")
              : room.winnerId == _authService.getUid()
              ? Text("You Win!")
              : Text("You Lose!"),
          content: room.winnerId == null
              ? Text("No winner")
              : room.winnerId == room.creatorId
              ? Text("The winner is ${room.creatorName}")
              : Text("The winner is ${room.opponentName}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.homeRouteName);
              },
              child: Text("Back Home"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateStatistics(Room room) async {
    if (room.winnerId == null) {
      await _playerService.updateDraws(room.creatorId);
      await _playerService.updateDraws(room.opponentId!);
    } else {
      if (room.winnerId == room.creatorId) {
        await _playerService.updateWins(room.creatorId);
        await _playerService.updateLoses(room.opponentId!);
      } else if (room.winnerId == room.opponentId) {
        await _playerService.updateWins(room.opponentId!);
        await _playerService.updateLoses(room.creatorId);
      }
    }
  }

  Future<void> handleStatistics(Room room) async {
    await _roomService.updateStat(room.roomId!);
    await updateStatistics(room);
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder<Room?>(
      stream: _roomService.streamRoom(roomId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.hasData) {
          final room = snapshot.data!;

          if (room.roomState == RoomState.finished && !_dialogShown) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showResultDialog(room);
            });
            _dialogShown = true;
          }
          if (room.roomState == RoomState.finished &&
              _authService.getUid() == room.creatorId &&
              !room.updateStat) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              handleStatistics(room);
            });
          }
          if (room.opponentId == null &&
              _authService.getUid() != room.creatorId) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, RouteName.availableRoomsRouteName);
            });
          }
          return Scaffold(
            appBar: AppBar(),
            drawer: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.height * .2,
                child: Drawer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _authService.getUid() == room.opponentId
                            ? () async {
                                await _roomService.updateWinner(
                                  roomId,
                                  room.creatorId,
                                );

                                await _roomService.updateRoomState(
                                  roomId,
                                  RoomState.finished,
                                );
                                Navigator.pushNamed(
                                  context,
                                  RouteName.homeRouteName,
                                );
                              }
                            : () async {
                                await _roomService.updateWinner(
                                  roomId,
                                  room.opponentId!,
                                );

                                await _roomService.updateRoomState(
                                  roomId,
                                  RoomState.finished,
                                );
                                Navigator.pushNamed(
                                  context,
                                  RouteName.homeRouteName,
                                );
                              },
                        child: Row(
                          children: [Text("Leave game"), Icon(Icons.login)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Player 1",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: myPurple,
                      ),
                    ),
                    Text(
                      "Player 2",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: myYellow,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      room.creatorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      room.opponentName!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          move(index, room);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              room.board[index],
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: room.board[index] == "X"
                                    ? myPurple
                                    : myYellow,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  "${room.xTurn ? room.creatorName : room.opponentName!} 's turn",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.red,
                    child: Center(
                      child: CountdownTimer(
                        turnStartAt: room.turnStartAt!,
                        board: room.board,
                        roomId: room.roomId!,
                        xTurn: room.xTurn,
                        isMyTurn: room.xTurn
                            ? _authService.getUid() == room.creatorId
                            : _authService.getUid() == room.opponentId,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          );
        }
        return const Center(child: Text("Room not found"));
      },
    );
  }
}

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
