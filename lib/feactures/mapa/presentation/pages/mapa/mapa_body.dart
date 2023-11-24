import 'package:driver_ambulance/feactures/mapa/presentation/providers/mapa/camera_position_provider.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/providers/mapa/map_controller_provider.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/providers/mapa/markers_provider.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/providers/mapa/microphone_provider.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/widgets/search_destino.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/widgets/search_origen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/mapa/polyline_travel_provider.dart';
import '../../providers/mapa/polylines_provider.dart';

class MapaBody extends ConsumerStatefulWidget {
  final TextEditingController textOriginController;
  const MapaBody({super.key, required this.textOriginController});

  @override
  MapaBodyState createState() =>
      MapaBodyState(origenController: textOriginController);
}

class MapaBodyState extends ConsumerState<MapaBody> {
  GoogleMapController? mapController;
  final TextEditingController origenController; // = TextEditingController();
  Set<Marker> markers = {};
  MapaBodyState({required this.origenController});

  @override
  void initState() {
    super.initState();
    determinePosistion();
    getCurrentLocation();
  }

  LatLng? myPosition;
  Future<Position> determinePosistion() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosistion();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rutaPolylines = ref.watch(mapPolylineProvider);
    final polylines = ref.watch(polylineTravelProvider);
    if (myPosition != null) {
      ref
          .read(polylineTravelProvider.notifier)
          .addPolyline(myPosition!, LatLng(-17.780153, -63.180051));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: myPosition == null
          ? const CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 2,
            )
          : Stack(
              children: [
                GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) => ref
                      .read(mapCreatedProvider.notifier)
                      .setMapController(controller),
                  initialCameraPosition:
                      CameraPosition(target: myPosition!, zoom: 14),
                  polylines: {polylines},
                ),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.center, child: _getMarker())),
              ],
            ),
      drawer: const NavigationDrawer(
        children: [
          Column(
            children: [
              CustomCard(
                text: 'Emergencia asignada',
                color: Colors.blue,
              ),
              SizedBox(height: 20), // Espacio entre la tarjeta y los datos

              // Datos de la solicitud
              RequestInfo(
                id: 'SOL-1234',
                description: 'Descripción de la solicitud...',
                imageUrl:
                    "https://i.pinimg.com/originals/fd/82/c1/fd82c1116eb734b625552241e00e2a20.png",
                time: '10:00 AM',
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.asset("assets/profile.jpg")),
    );
  }

  Future<String> getAddress(LatLng point) async {
    final placemarks = await placemarkFromCoordinates(
      point.latitude,
      point.longitude,
      localeIdentifier: 'es',
    );

    String ubicacion = placemarks.first.thoroughfare ?? '';

    return placemarks.first.thoroughfare == '' ? 'Ubicación actual' : ubicacion;
  }
}

class CustomCard extends StatelessWidget {
  final String text;
  final Color color;

  const CustomCard({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class RequestInfo extends StatelessWidget {
  final String id;
  final String description;
  final String imageUrl;
  final String time;

  const RequestInfo({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Numero de solicitud: $id'),
            subtitle: Text('Tiempo: $time'),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Descripción:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(description),
                const SizedBox(height: 10),
                Image.network(
                  imageUrl,
                  height: 400,
                  width: 400,
                ), // Aquí puedes cargar la imagen desde la URL
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRoute extends StatelessWidget {
  const _InfoRoute({
    super.key,
    required this.selected,
    required this.ref,
  });

  final Set<TravelMode> selected;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      style: ButtonStyle(),
      segments: [
        ButtonSegment(value: TravelMode.driving, icon: Text('vehiculo')),
        ButtonSegment(value: TravelMode.walking, icon: Text('caminando')),
      ],
      selected: selected,
      onSelectionChanged: (value) {
        ref.read(mapPolylineProvider.notifier).update(travelMode: value.first);
      },
    );
  }
}
