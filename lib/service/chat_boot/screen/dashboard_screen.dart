import 'package:flutter/material.dart';
import 'package:workshop_app/service/chat_boot/screen/chat_screen.dart';
import 'package:workshop_app/service/chat_boot/utils/app_constant.dart';
import 'package:workshop_app/service/chat_boot/utils/util_helper.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: Text.rich(
          TextSpan(
            text: "Me",
            style: mTextStyle25(fontColor: Colors.white),
            children: [
              TextSpan(
                text: "Chanix",
                style: mTextStyle25(fontColor: Colors.lightBlueAccent),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade700,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: const Icon(Icons.face, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text("New chat", style: mTextStyle18(fontColor: Colors.lightBlueAccent)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.history, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text("History", style: mTextStyle18(fontColor: Colors.lightBlueAccent)),
                    ],
                  )
                ],
              ),
            ),
            // Search Text field
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    style: mTextStyle18(fontColor: Colors.white),
                    onSubmitted: (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(query: searchController.text)));
                    },
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "استفسر عن أي قطعة غيار هنا",
                      hintStyle: mTextStyle18(fontColor: Colors.white54),
                      filled: true,
                      fillColor: Colors.blueGrey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade700,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        query: searchController.text)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 6),
                              child: Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tab Bar
            SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: AppConstant.defaultQues.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: index == selectedIndex
                            ? Border.all(width: 1, color: Colors.lightBlueAccent)
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: Center(
                          child: Text(
                            AppConstant.defaultQues[index]["title"],
                            style: index == selectedIndex
                                ? mTextStyle18(fontColor: Colors.lightBlueAccent)
                                : mTextStyle18(fontColor: Colors.white60),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
              const SizedBox(height: 20),
            // Quick Questions Grid
            Expanded(
              child: GridView.builder(
                itemCount: AppConstant.defaultQues[selectedIndex]['question'].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 8, mainAxisSpacing: 8, crossAxisCount: 2),
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      AppConstant.defaultQues[selectedIndex]['question'][index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(query: data['ques'])));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 11),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: data['color'],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      data['icon'],
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                data['ques'],
                                style: mTextStyle18(
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
