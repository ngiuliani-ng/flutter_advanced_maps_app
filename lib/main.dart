import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  static final CameraPosition startPosition = CameraPosition(
    target: LatLng(40.785091, -73.968285),
    tilt: 0,
    bearing: 0,
    zoom: 15,
  );

  static final CameraPosition endPosition = CameraPosition(
    target: LatLng(40.780091, -73.962185),
    tilt: 0,
    bearing: 0,
    zoom: 15,
  );

  /// La classe [Completer] viene utilizzata per produrre oggetti [Future]
  /// e per completarli successivamente con un valore o con un errore.
  /// Questa classe ci permette di configurare in maniera dinamica gli oggetti [Future]
  /// e di fare l'await di questi in un altro posto.

  final Completer<GoogleMapController> googleMapController = Completer();
  final Completer<String> googleMapStyle = Completer();

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    rootBundle.loadString("assets/styles/googleMap.json").then((style) => googleMapStyle.complete(style));
    setupMap();
  }

  void setMarker({
    @required CameraPosition position,
    @required String info,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(
          position.target.toString(),
        ),
        position: position.target,
        infoWindow: InfoWindow(
          title: info,
        ),
      ),
    );
  }

  void setPolyline({
    @required CameraPosition startPosition,
    @required CameraPosition endPosition,
  }) {
    polylines.add(
      Polyline(
        polylineId: PolylineId(
          startPosition.target.toString() + endPosition.target.toString(),
        ),
        points: [startPosition.target, endPosition.target],
        color: Colors.black,
        width: 4,
      ),
    );
  }

  void setupMap() async {
    final map = await googleMapController.future;
    final mapStyle = await googleMapStyle.future;

    map.setMapStyle(mapStyle);

    setState(() {
      setMarker(
        position: startPosition,
        info: "Start Position",
      );
      setMarker(
        position: endPosition,
        info: "End Position",
      );
      setPolyline(
        startPosition: startPosition,
        endPosition: endPosition,
      );
    });
  }

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
        body: map(),
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
        transportMode(asset: "assets/images/UberX.jpg", name: "UberX", time: "12:05", price: 15.50),
        transportMode(asset: "assets/images/UberPool.jpg", name: "Pool", time: "12:15", price: 10.15),
        Divider(
          thickness: 1,
        ),
        lowerSection(),
      ],
    );
  }

  Widget transportMode({
    @required String asset,
    @required String name,
    @required String time,
    @required double price,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      leading: Image.asset(
        asset,
        height: 50,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        time,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
      trailing: Text("\$${price.toStringAsFixed(2)}"),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          "BOOK RIDE",
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget map() {
    return GoogleMap(
      initialCameraPosition: startPosition,
      zoomControlsEnabled: false,
      markers: markers,
      polylines: polylines,
      onMapCreated: (GoogleMapController controller) {
        this.googleMapController.complete(controller);
      },
    );
  }
}
