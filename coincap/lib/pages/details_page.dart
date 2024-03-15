import 'package:flutter/material.dart';

class DetailsPages extends StatelessWidget {
  final Map rate;
  const DetailsPages({required this.rate});
  @override
  Widget build(BuildContext context) {
    List _currenciesMap = rate.keys.toList();
    List _exchangeRateMap = rate.values.toList();
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: _currenciesMap.length,
              itemBuilder: (_context, _index) {
                String _currency =
                    _currenciesMap[_index].toString().toUpperCase();
                String _exchangeRate =
                    _exchangeRateMap[_index].toString().toUpperCase();

                return ListTile(
                  title: Text(
                    "$_currency : $_exchangeRate",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              })),
    );
  }
}
