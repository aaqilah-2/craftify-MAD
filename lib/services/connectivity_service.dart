// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:async';
//
// class ConnectivityService {
//   // StreamController to broadcast the connectivity changes
//   StreamController<ConnectivityResult> connectivityStreamController =
//   StreamController<ConnectivityResult>();
//
//   ConnectivityService() {
//     // Listen to connectivity changes
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       connectivityStreamController.add(result); // Add changes to the stream
//     });
//   }
//
//   // Method to get the current status of connectivity
//   Future<ConnectivityResult> checkConnectivity() async {
//     return await Connectivity().checkConnectivity();
//   }
//
//   // Dispose the stream when not needed
//   void dispose() {
//     connectivityStreamController.close();
//   }
// }
