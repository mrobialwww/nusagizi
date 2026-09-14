extension DoubleFormatter on double {
  String toMacroFormat() {
    if (this % 1 == 0) {
      return toInt().toString();
    }
    return toStringAsFixed(1);
  }
}
