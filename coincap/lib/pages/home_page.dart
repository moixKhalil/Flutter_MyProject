import 'dart:convert';

import 'package:coincap/pages/details_page.dart';
import 'package:coincap/services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  String? _selectedCoin = "bitcoin";
  HTTPService? _http;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectCoinDropDown(),
            _dataWidgets(),
          ],
        ),
      )),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
        future: _http!.get("/coins/$_selectedCoin"),
        builder: (
          BuildContext _context,
          AsyncSnapshot _snapShot,
        ) {
          if (_snapShot.hasData) {
            Map _data = jsonDecode(_snapShot.data.toString());
            num _usdPrice = _data["market_data"]["current_price"]["usd"];
            num _chane24h = _data["market_data"]["price_change_percentage_24h"];
            Map _exchangeRates = _data["market_data"]["current_price"];
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DetailsPages(
                        rate: _exchangeRates,
                      );
                    }));
                  },
                  child: _coinImageWidget(
                    _data["image"]["large"], // Using ? for null-aware access
                  ),
                ),
                _currentPriceWidget(_usdPrice),
                _percentageChangeWidget(_chane24h),
                _descriptionCardWidget(_data["description"]["en"]),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _coinImageWidget(String _imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration:
          BoxDecoration(image: DecorationImage(image: NetworkImage(_imgURL))),
    );
  }

  Widget _descriptionCardWidget(String _discription) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      color: Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        _discription,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "${_change.toString()} %",
      style: TextStyle(
          fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300),
    );
  }

  Widget _selectCoinDropDown() {
    List<String> _coins = [
      "bitcoin",
      "ethereum",
      "tether",
      "cardano",
      "ripple"
    ];
    List<DropdownMenuItem<String>> _items = _coins
        .map((String e) => DropdownMenuItem(child: Text(e), value: e))
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      items: _items,
      onChanged: (_value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      style: TextStyle(
          color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600),
      underline: Container(),
      icon: Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
    );
  }
}
