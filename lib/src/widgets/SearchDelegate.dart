import 'package:capacity_control_admin_app/src/api/DataProvider.dart';
import 'package:capacity_control_admin_app/src/pages/InfoPlace.dart';
import 'package:capacity_control_admin_app/src/widgets/CustomPageRoute.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  final DataProvider dataProvider = new DataProvider();

  DataSearch()
      : super(
          searchFieldLabel: 'Buscar establecimiento',
          keyboardType: TextInputType.text,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(future: dataProvider.searchPlaces(query), builder: _listTileView);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(future: dataProvider.searchPlaces(query), builder: _listTileView);
  }

  Widget _listTileView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      final places = snapshot.data;
      return ListView(
        children: places.map<Widget>((place) {
          final double percentage = (place.currentUsers / place.maxCapacityPermited) * 100;
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: percentage < 70
                  ? Colors.green
                  : percentage < 80
                      ? Colors.amber
                      : Colors.red,
            ),
            title: Text(place.name),
            subtitle: Text(place.address),
            trailing: Text('${percentage.toStringAsFixed(1)}%'),
            onTap: () {
              close(context, null);
              Navigator.of(context).push(CustomPageRoute(InforPlacePage(
                place: place,
              )));
            },
          );
        }).toList(),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
