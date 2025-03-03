import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> chats = [
    {"name": "Наиль", "lastMessage": "Привет!", "time": "12:30", "read": true},
    {
      "name": "Латифа",
      "lastMessage": "Привет!",
      "time": "12:30",
      "read": false
    },
    {"name": "Маша", "lastMessage": "Привет!", "time": "12:30", "read": true},
    {
      "name": "Юлиана",
      "lastMessage": "Привет!",
      "time": "12:30",
      "read": false
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              child: Icon(Icons.person),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Text("Chats"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.93,
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                    title: Text(chats[index]["name"]!),
                    subtitle: Text(
                      chat["lastMessage"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: chat["read"] ? Colors.grey : Colors.black,
                        fontWeight:
                            chat["read"] ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chat["time"],
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        chat["read"]
                            ? Icon(
                                Icons.done_all,
                                color: Colors.blue,
                                size: 18,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 8,
                              ),
                      ],
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/chatPage');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            //Navigator.popAndPushNamed(context, '/chats');
          } else if (index == 1) {
            Navigator.popAndPushNamed(context, '/contacts');
          }
        },
      ),
    );
  }
}
