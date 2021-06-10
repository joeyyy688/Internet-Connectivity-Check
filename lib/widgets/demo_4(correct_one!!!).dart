import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Demo4 extends StatefulWidget {
  @override
  _Demo4State createState() => _Demo4State();
}

class _Demo4State extends State<Demo4> {
  bool isThereInternet = true;
  // Future<bool> checkInternetStatus() async {
  //   // InternetConnectionChecker().hasConnection.then((value) {
  //   //   print(value);
  //   // });
  //   bool result = await InternetConnectionChecker().hasConnection;
  //   print(result);
  //   return result;
  // }

  Future<void> internetConnectionChecker() async {
    // Simple check to see if we have Internet
    print('The statement \'this machine is connected to the Internet\' is: ');
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    print(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    print(
        'Current status: ${await InternetConnectionChecker().connectionStatus}');
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print('Last results: ${InternetConnectionChecker().lastTryResults}');

    // actively listen for status updates
    StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            this.setState(() {
              isThereInternet = true;
            });
            break;
          case InternetConnectionStatus.disconnected:
            print('You are disconnected from the internet.');
            this.setState(() {
              isThereInternet = false;
            });
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //checkInternetStatus().then((value) => print(value));
    //print(InternetConnectionChecker().lastTryResults);
    internetConnectionChecker();

    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none ||
            isThereInternet == false) {
          return Column(
            children: [
              Container(
                height: 500,
                color: Colors.white70,
                child: Center(
                  child: Text(
                    'Oops, \n\nWe experienced a Delayed Offline!',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              TextButton(
                  onPressed: internetConnectionChecker,
                  child: Text("try again"))
            ],
          );
        }

        return child;
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'There are no bottons to push :)',
            ),
            Text(
              'Just turn off your internet.',
            ),
            Text(
              'This one has a bit of a delay.',
            ),
          ],
        ),
      ),
    );
  }
}
