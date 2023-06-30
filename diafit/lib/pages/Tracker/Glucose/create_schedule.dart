import 'package:diafit/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  @override
  List<PendingNotificationRequest>? notifications;
  // TimeOfDay? time;
  // List<TimeOfDay?> schedule = [];

  // @override
  // void initState() {
  //   getTime();
  // }

  // void getTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? savedStrList = prefs.getStringList("schedule");
  //   schedule = savedStrList!.map((i) => timeConvert(i)).toList();
  //   print(schedule);
  // }

  // TimeOfDay timeConvert(String time) {
  //   time = time.split("(")[1].split(")")[0];
  //   return TimeOfDay(
  //       hour: int.parse(time.split(":")[0]),
  //       minute: int.parse(time.split(":")[1]));
  // }

  // void storeTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> strList = schedule.map((i) => i.toString()).toList();
  //   prefs.setStringList("schedule", strList);
  //   getTime();
  // }

  Future<void> inputNotification() async {
    TimeOfDay? time = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
    DateTime now = DateTime.now();
    DateTime date =
        DateTime(now.year, now.month, now.day, time!.hour, time.minute);
    NotificationService().createGlucoseReminderNotification(
      scheduledNotificationDateTime: date,
      title: "diafit",
      body: "its time to check your sugar level",
      // kirim waktunya lewat payload
      payLoad: date.toString(),
    );
  }

  Future<void> getNotification() async {
    notifications = await NotificationService().showPendingNotifications();
  }

  Future<void> cancelNotification() async {
    await NotificationService().cancelAllNotification();
  }

  // void deleteTime() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: getNotification(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error occured'),
                );
              } else {
                if (notifications!.isNotEmpty) {
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notifications!.length,
                        itemBuilder: (context, index) {
                          return MyCard(
                              notification:
                                  notifications![index].payload.toString());
                        },
                      ),
                    ],
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child:
                        Image.asset('assets/images/image-removebg-preview.png'),
                  );
                }
              }
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Add',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await inputNotification();
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Cancel',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await cancelNotification();
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String notification;
  const MyCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              notification,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
    return Container(
      height: 100,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Row(children: [
        Text(notification),
      ]),
    );
  }
}
