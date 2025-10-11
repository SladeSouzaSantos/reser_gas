extension ConverterUnidades on double {

  double temperaturaFahrenheitToRankine () {
    return this + 459.67;
  }

  double temperaturaCelsiusToRankine () {
    return (this * (9 / 5)) + 491.67;
  }

  double temperaturaKelvinToRankine () {
    return this * 1.8;
  }

  double pressaokPaToPsia () {
    return this * 0.145038;
  }

  double pressaokgfcm2ToPsia () {
    return this * 14.223;
  }

  double pressaoatmToPsia () {
    return this * 14.696;
  }

  double pressaobarToPsia () {
    return this * 14.504;
  }

}