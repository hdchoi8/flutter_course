import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_course/helper/ensure-visible.dart';
import 'package:map_view/map_view.dart';

const API_KEY = "AIzaSyBq-yjGMlSyF4hcKq3vJVq-XlHNvyRDBVk";

class LocationInput extends StatefulWidget {
  LocationInput({Key key}) : super(key: key);

  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  Uri _staticMapUri;
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    getStaticMap("String address");
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      return;
    }
    final Uri uri = Uri.https('maps.googleais.com', '/maps/api/geocode/json',
        {'address': address, 'key': API_KEY});
    final http.Response response = await http.get(uri);
    final StaticMapProvider staticMapviewProvider = StaticMapProvider(API_KEY);
    final Uri staticMapUri = staticMapviewProvider.getStaticUriWithMarkers(
        [Marker('position', 'position', 41.40338, 2.17403)],
        center: Location(41.40338, 2.17403),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);
    setState(() {
      _staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {
    if (_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            controller: _addressInputController,
            focusNode: _addressInputFocusNode,
            decoration: InputDecoration(labelText: "Address"),
          ),
        ),
        SizedBox(height: 10.0),
        Image.network(_staticMapUri.toString()),
      ],
    );
  }
}
