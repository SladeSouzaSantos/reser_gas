import 'dart:math';

extension Log10 on double{
  double log10() {
    return log(this) / log(10);
  }
}