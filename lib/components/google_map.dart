import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/manager.dart';


class RGoogleMap extends StatefulWidget {
  const RGoogleMap({Key? key}) : super(key: key);

  @override
  RGoogleMapState createState() => RGoogleMapState();
}

class RGoogleMapState extends State<RGoogleMap> {
  final LatLng startLocation = const LatLng(18.790894, 78.911850);

  
  @override
  Widget build(BuildContext context) {

    LocationManager locationManager = Provider.of<LocationManager>(context, listen: false);

    return GoogleMap(
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: startLocation,
        zoom: 14.4746,
      ),
      mapType: MapType.normal,
      onMapCreated: (controller) {
        setState(() {
          locationManager.setMapController(controller);
        });
      },
      onCameraMove: (CameraPosition cameraPosition) {
        cameraPosition = cameraPosition;
      },/*
      onCameraIdle: () async {
        List<Placemark> placeMarks = await placemarkFromCoordinates(
            cameraPosition!.target.latitude,
            cameraPosition!.target.longitude);
      },*/
    );
  }

}
