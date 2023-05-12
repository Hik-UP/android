bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  try {
    double.parse(s);
    return true;
  } catch (e) {
    return false;
  }
}
