import 'package:final_project/models/room.dart';
import 'package:final_project/models/room_card.dart';
import 'package:final_project/services/room_service.dart';
import 'package:flutter/material.dart';

class AvailableRooms extends StatefulWidget {
  const AvailableRooms({super.key});

  @override
  State<AvailableRooms> createState() => _AvailableRoomsState();
}

class _AvailableRoomsState extends State<AvailableRooms> {
  final RoomService _roomService = RoomService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Rooms")),
      body: StreamBuilder<List<Room>>(
        stream: _roomService.getAvailableRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.hasData) {
            List<Room> rooms = snapshot.data!;
            if (rooms.isEmpty) {
              return const Center(child: Text("No available rooms"));
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return RoomCard(
                  creator: rooms[index].creatorName,
                  creatorId: rooms[index].creatorId,
                  state: rooms[index].roomState.name,
                  roomId: rooms[index].roomId!,
                  
                );
              },
            );
          }
          return const Center(child: Text("Room not found"));
        },
      ),
    );
  }
}
