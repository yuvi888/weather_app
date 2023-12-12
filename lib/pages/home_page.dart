import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_tutorial/constant/colors.dart';
import 'package:weather_app_tutorial/constant/consts.dart';
import 'package:weather_app_tutorial/constant/custom_textfied.dart';
import 'package:weather_app_tutorial/constant/dilogbox.dart';

import 'package:weather_app_tutorial/pages/intro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        _fetchWeather(position.latitude, position.longitude);
      }
    } catch (e) {
      showCustomAlertDialog(context, e.toString());
    }
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    try {
      Weather weather = await _wf.currentWeatherByLocation(latitude, longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      showCustomAlertDialog(context, e.toString());
    }
  }

  Future<void> _searchWeather(String cityName) async {
    try {
      Weather weather = await _wf.currentWeatherByCityName(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      showCustomAlertDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: Container(
              padding: EdgeInsets.only(top: 20), child: _searchBar())),
      body: _buildUI(),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          child: Icon(
            Icons.refresh,
            color: GlobalVariables.textColor,
            size: 30,
          ),
          backgroundColor: GlobalVariables.backgroundColor,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const IntroPage();
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          _locationHeader(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              _weather?.areaName ?? "",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.textColor,
              ),
            ),
          ),
          Container(
            child: Text(
              _weather?.country ?? "",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            child: Center(
              child: Image.asset(
                'assets/4.png',
                width: 70,
                height: 70,
              ),
            ),
          ),
          Expanded(
            child: CustomTextField(
              controller: _cityController,
              hintText: "Enter city name",
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: GlobalVariables.textColor,
              size: 30,
            ),
            onPressed: () {
              String cityName = _cityController.text.trim();
              if (cityName.isNotEmpty) {
                _searchWeather(cityName);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            DateFormat("h:mm a").format(now),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: GlobalVariables.textColor,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("EEE ,").format(now),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: GlobalVariables.textColor,
                ),
              ),
              Text(
                "  ${DateFormat('MMM d').format(now)}",
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: GlobalVariables.textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: GlobalVariables.textColor,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: const TextStyle(
        color: GlobalVariables.textColor,
        fontSize: 60,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/windspeed.gif',
              ),
              Text(
                " Wind Speed ",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
              Text(
                "${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/humidity.png',
                height: 40,
                width: 40,
              ),
              Text(
                " Humidity ",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
              Text(
                "${_weather?.humidity?.toStringAsFixed(0)} %",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Max : ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
              Image.asset(
                'assets/thermometer.gif',
              ),
              Text(
                "Min : ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/clouds.gif',
              ),
              Text(
                " Cloudines ",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
              Text(
                "${_weather?.cloudiness} %",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/sunrise.gif',
              ),
              Text(
                " Sunrise ",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
              Text(
                "${_weather != null ? DateFormat('hh:mm a').format(_weather!.sunrise!.toLocal()) : ''}",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/sunset.gif',
              ),
              Text(
                " Sunset ",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
              Text(
                "${_weather != null ? DateFormat('hh:mm a').format(_weather!.sunset!.toLocal()) : ''}",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
