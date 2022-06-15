
import 'package:challenge_flutter/src/data/sqlite_helper.dart';
import 'package:challenge_flutter/src/model/story.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // All journals
  List<Story> lstStory = [];
  int itemIndex = 0;
  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    setState(() => _isLoading = true);
    lstStory = await StoryDatabase.instance.getItems();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    StoryDatabase.instance.getData().whenComplete(() => _refreshData());
  }
  @override
  void dispose() {
    StoryDatabase.instance.close();

    super.dispose();
  }
  // Update an existing journal
  Future<void> _updateItem(int id, String title, bool liked) async {
    await StoryDatabase.instance.updateItem(id, title, liked);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset("assets/img/logo.PNG"),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Handicrafted by",
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black54)),
              Text("Jim HLS",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                      color: Colors.black))
            ],
          ),
          Container(
            margin: EdgeInsets.all(2.sp),
            child: Image.asset("assets/img/imgUser.PNG"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: 100.w,
                padding: EdgeInsets.only(
                    top: 30.sp, right: 10.sp, left: 10.sp, bottom: 25.sp),
                color: Colors.green,
                child: Column(
                  children: [
                    Text("  A joke a day keeps the doctor away",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: Colors.white)),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Text(
                        "if you joke wrong way, your teeth have to pay. (Seriour)",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10.sp,
                            color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          lstStory.length > 0
                              ? lstStory[itemIndex].title!
                              : "fail",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black54))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      fixedSize: MaterialStateProperty.all(Size(100.sp, 30.sp)),
                    ),
                    onPressed: () {
                      if (lstStory.length - 1 > itemIndex) {
                        _updateItem(lstStory[itemIndex].id,
                            lstStory[itemIndex].title!, true);
                        itemIndex++;
                        setState(() {});
                      }
                    },
                    child: Text('This is Funny!'),
                  ),
                  SizedBox(
                    width: 15.sp,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      fixedSize: MaterialStateProperty.all(Size(100.sp, 30.sp)),
                    ),
                    onPressed: () {
                      if (lstStory.length - 1 > itemIndex) {
                        _updateItem(lstStory[itemIndex].id,
                            lstStory[itemIndex].title!, false);
                        itemIndex++;
                        setState(() {});
                      }
                    },
                    child: Text('This is not Funny'),
                  )
                ],
              ),
              Divider(),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                child: Text(
                    "This appis created as  part of Hlsolutions program. the materials con-tained on this website are provided for general information only and do not  consitute any form  of advice. HLS assumes no responsibility for the accuracy of any particular statement and accepts no liability for any loss or damage which may arise from reliance on the infor-mation contained on this site.",
                    style: TextStyle(fontSize: 10.sp, color: Colors.black54)),
              ),
              Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: Text('Copyright 2021 HLS',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          color: Colors.black54))),
              Divider(),
            ],
          ),
        ),
      ),
    ));
  }
}
