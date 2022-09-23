import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/manager.dart';
import 'package:untitled/manager/service_request_manager.dart';
import 'package:untitled/model/customer.dart';

import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/vendor.dart';


class RGoogleMap extends StatefulWidget {
  LatLng? currentLocation;
  RGoogleMap({
    Key? key,
    this.currentLocation
  }) : super(key: key);

  @override
  RGoogleMapState createState() => RGoogleMapState();
}

class RGoogleMapState extends State<RGoogleMap> {
  final LatLng startLocation = const LatLng(18.790894, 78.911850);
  List<Marker> _markers = [];
  
  @override
  Widget build(BuildContext context) {
    LocationManager locationManager = Provider.of<LocationManager>(context, listen: false);
    return GoogleMap(
      zoomGesturesEnabled: true,
      initialCameraPosition: CameraPosition(
        target: widget.currentLocation ?? startLocation,
        zoom: 14,
      ),
      mapType: MapType.normal,
      markers: _markers.toSet(),
      onMapCreated: (controller) {
          final marker = Marker(
              position: widget.currentLocation ?? startLocation,
              markerId: const MarkerId('0'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed)
          );
          _markers.add(marker);

        setState(() {
          locationManager.setMapController(controller);
        });
      },
      onCameraMove: (position) {
        setState(() {
          _markers.first =
              _markers.first.copyWith(positionParam: position.target);
        });
      },
    );
  }

}
