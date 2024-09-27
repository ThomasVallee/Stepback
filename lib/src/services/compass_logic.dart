import 'dart:math';

double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
  double lat1Rad = lat1 * pi / 180.0;
  double lon1Rad = lon1 * pi / 180.0;
  double lat2Rad = lat2 * pi / 180.0;
  double lon2Rad = lon2 * pi / 180.0;

  double dLon = lon2Rad - lon1Rad;

  double y = sin(dLon) * cos(lat2Rad);
  double x = cos(lat1Rad) * sin(lat2Rad) -
      sin(lat1Rad) * cos(lat2Rad) * cos(dLon);

  double bearingRad = atan2(y, x);
  double bearingDeg = (bearingRad * 180.0 / pi + 360.0) % 360.0;

  return bearingDeg;
}
