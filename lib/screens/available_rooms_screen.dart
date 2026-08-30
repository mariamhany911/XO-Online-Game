import 'package:final_project/models/room.dart';
import 'package:final_project/models/room_card.dart';
import 'package:final_project/services/room_service.dart';
import 'package:flutter/material.dart';

class AvailableRooms extends StatefulWidget {
  const AvailableRooms({super.key});

  @override
  State<AvailableRooms> createState() => _AvailableRoomsState();
}

class _AvailableRoomsState extends State<AvailableRooms>  {

  final RoomService _roomService = RoomService();
  List<Room> rooms =[];

  Future<void> getRooms()async{
    rooms = await  _roomService.getAvailableRooms();
    setState(() {});
  }
  
  @override
  void initState() {
    super.initState();
    getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Rooms"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
        itemCount: rooms.length,
      itemBuilder: (context,index){
        return RoomCard(
          creator: rooms[index].creatorName,
           state: rooms[index].roomState.name,
           roomId: rooms[index].roomId!,
           );
      },
      )
    );
  }
}