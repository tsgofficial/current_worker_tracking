import 'dart:async';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_pro/Controller/MapScreenController.dart';
import 'package:google_maps_pro/Repos/GetLocSocketEmit.dart';
import 'package:google_maps_pro/Repos/LocationService.dart';
import 'package:google_maps_pro/Repos/WorkManager.dart';
import 'package:google_maps_pro/Screens/RootScreen/RootScreen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mapScreenController = Get.put(MapScreenController());

  Connectivity().onConnectivityChanged.listen(
    (ConnectivityResult result) async {
      mapScreenController.isDeviceConnected.value =
          await InternetConnectionChecker().hasConnection;
    },
  );
  await Permission.location.isDenied.then((value) {
    if (value) {
      Permission.location.request();
    }
  });

  await GetLocSocketEmit().checkPermission();
  await LocationService().getLocation();

  if (Platform.isAndroid) {
    WorkManager().initWorkManager();
  }

  runApp(const MyApp());

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, background: Colors.white),
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}
