import 'dart:async';

import 'package:abhicaresservice/helper/googlemapapi.dart';
import 'package:abhicaresservice/screens/pages/booking_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

class MapScreen extends StatefulWidget {
  // final curlang;
  // final curlat;
  final destlat;
  final destlang;
  final id;
  const MapScreen({super.key, 
    // required this.curlang,
    // required this.curlat,
    required this.id,
    required this.destlang,
    required this.destlat,
  });
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Position? location;
  Marker? sourcePosition, destinationPosition;
  Position? _currentPosition;
  LatLng curLocation = const LatLng(23.0525, 72.5667);
  StreamSubscription<Position>? locationSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: const MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destlat, widget.destlang),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }

  getNavigation() async {
    bool serviceEnabled;
    LocationPermission permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await Geolocator.checkPermission();
    if (permissionGranted == LocationPermission.denied) {
      permissionGranted = await Geolocator.requestPermission();
      if (permissionGranted != LocationPermission.always) {
        return;
      }
    }
    if (permissionGranted == LocationPermission.always) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );
      curLocation =
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      locationSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position currentLocation) {
        controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 16,
        )));
        if (mounted) {
          controller
              ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
          setState(() {
            curLocation =
                LatLng(currentLocation.latitude, currentLocation.longitude);
            sourcePosition = Marker(
              markerId: MarkerId(currentLocation.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              infoWindow: InfoWindow(
                  title:
                      '${double.parse((getDistance(LatLng(widget.destlat, widget.destlang)).toStringAsFixed(2)))} km'),
              onTap: () {
                print('market tapped');
              },
            );
          });
          getDirections(LatLng(widget.destlat, widget.destlang));
        }
      });
    }
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GoogleMapApi.API_KEY,
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      }
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourcePosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: curLocation,
                    zoom: 16,
                  ),
                  markers: {sourcePosition!, destinationPosition!},
                  onTap: (latLng) {
                    print(latLng);
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: 30,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const BookingInfoScreen(
                                    id: '',
                                  )),
                          (route) => false);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.navigation_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await launchUrl(Uri.parse(
                                'google.navigation:q=${widget.destlat}, ${widget.destlang}&key=${GoogleMapApi.API_KEY}'));
                          },
                        ),
                      ),
                    ))
              ],
            ),
    );
  }
}
