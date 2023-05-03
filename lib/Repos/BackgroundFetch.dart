import 'package:background_fetch/background_fetch.dart';

class BackgroundFETCH {
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  Future<void> initSmth() async {
    // Step 1:  Configure BackgroundFetch as usual.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(minimumFetchInterval: 15), (String taskId) async {
      // <-- Event callback.
      // This is the fetch-event callback.
      print("[BackgroundFetch] taskId: $taskId");

      // Use a switch statement to route task-handling.
      switch (taskId) {
        case 'com.background.fetch':
          print("Received custom task");
          break;
        default:
          print("Default fetch task");
      }
      // Finish, providing received taskId.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Event timeout callback
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });

// Step 2:  Schedule a custom "oneshot" task "com.transistorsoft.customtask" to execute 5000ms from now.
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.background.fetch", delay: 500 // <-- milliseconds
        ));
  }

  void onClickEnable(enabled) {
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void onClickStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
  }
}
