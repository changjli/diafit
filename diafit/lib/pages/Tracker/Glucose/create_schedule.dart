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
    print(notifications);
  }

  Future<void> cancelNotification() async {
    await NotificationService().cancelAllNotification();
  }

  // void deleteTime() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notifications!.length,
                    itemBuilder: (context, index) {
                      return Text(notifications![index].payload.toString());
                    },
                  );
                }
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await inputNotification();
              setState(() {});
            },
            child: const Text("add"),
          ),
          ElevatedButton(
            onPressed: () async {
              await cancelNotification();
              setState(() {});
            },
            child: const Text("cancel all"),
          )
        ],
      ),
    );
  }
}
