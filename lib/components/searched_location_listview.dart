import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/utils/add_space.dart';

class SearchedLocationListView extends StatefulWidget {
  final Image image;

  const SearchedLocationListView({Key? key,
    this.image = const Image(image: AssetImage('images/location_marker'))
  }): super(key: key);

  @override
  SearchedLocationListViewState createState() => SearchedLocationListViewState();
}

class SearchedLocationListViewState extends State<SearchedLocationListView> {


  @override
  Widget build(BuildContext context) {

    LocationManager locationManager = Provider.of<LocationManager>(context);
    VendorManager vendorManager = Provider.of<VendorManager>(context);

    return ListView.builder(
        itemCount: locationManager.searchedLocations.length,
        itemBuilder: (BuildContext context, int position) {
          return ListTile(
            title: Row(children: [
              //const Image(image: AssetImage('images/location_marker')),
              addVerticalSpace(20),
              Flexible(
                  child: Text(
                    locationManager.searchedLocations[position].description,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  )
              )
            ]),
            onTap: () async {
                final plist = GoogleMapsPlaces(
                  apiKey: locationManager.apiKey,
                  apiHeaders:
                  await const GoogleApiHeaders().getHeaders(),
                );

                final detail = await plist.getDetailsByPlaceId(locationManager.searchedLocations[position].placeId);
                final geometry = detail.result.geometry!;
                vendorManager.vendorRegistrationRequest.latitude = geometry.location.lat;
                vendorManager.vendorRegistrationRequest.longitude = geometry.location.lng;
                LatLng newLocation = LatLng(vendorManager.vendorRegistrationRequest.latitude as double,
                    vendorManager.vendorRegistrationRequest.longitude as double);
                List<Placemark> placeMarks = await placemarkFromCoordinates(
                    vendorManager.vendorRegistrationRequest.latitude as double, vendorManager.vendorRegistrationRequest.longitude as double);
                locationManager.setCurrentLocation = '${placeMarks[0].locality}, ${placeMarks[0].subLocality}';
                locationManager.mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newLocation, zoom: 14)));
                locationManager.clearSearchedLocations();
              },
          );
        });
  }

}