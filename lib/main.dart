import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 100,
        maxHeight: 300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        panel: panel(),
        body: maps(),
      ),
    );
  }

  Widget panel() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 4,
          margin: EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        transportMode(name: "UberX", time: "12:05", price: 15.50),
        transportMode(name: "Pool", time: "12:15", price: 10.15),
        Divider(
          thickness: 1,
        ),
        lowerSection(),
      ],
    );
  }

  Widget transportMode({@required String name, @required String time, @required double price}) {
    return ListTile(
      leading: Icon(
        Icons.car_rental,
        size: 40,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(time),
      trailing: Text("€${price.toStringAsFixed(2)}"),
    );
  }

  Widget lowerSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      child: MaterialButton(
        onPressed: () {},
        height: 50,
        minWidth: double.infinity,
        color: Colors.black,
        textColor: Colors.white,
        child: Text(
          "BOOK RIDE",
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget maps() {
    return Container(
      color: Colors.grey.shade400,
    );
  }
}
