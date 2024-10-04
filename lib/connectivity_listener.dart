// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'services/connectivity_service.dart';
// import 'dart:async';
//
// class ConnectivityListener extends StatefulWidget {
//   final Widget child;
//
//   ConnectivityListener({required this.child});
//
//   @override
//   _ConnectivityListenerState createState() => _ConnectivityListenerState();
// }
//
// class _ConnectivityListenerState extends State<ConnectivityListener> {
//   late ConnectivityService _connectivityService;
//   late StreamSubscription<ConnectivityResult> _subscription; // Corrected StreamSubscription
//
//   @override
//   void initState() {
//     super.initState();
//     _connectivityService = ConnectivityService();
//     _subscription = _connectivityService.connectivityStreamController.stream
//         .listen((ConnectivityResult result) {
//       _showConnectivitySnackBar(result);
//     });
//   }
//
//   void _showConnectivitySnackBar(ConnectivityResult result) {
//     final isConnected = result != ConnectivityResult.none;
//     final message = isConnected ? 'Connected to the Internet' : 'No Internet Connection';
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isConnected ? Colors.green : Colors.red,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel(); // Cancel the subscription when the widget is disposed
//     _connectivityService.dispose(); // Dispose the service
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
