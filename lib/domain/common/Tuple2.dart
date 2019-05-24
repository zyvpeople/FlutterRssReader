import 'package:collection/collection.dart';

class Tuple2<A, B> {
  final A value1;
  final B value2;
  final DeepCollectionEquality _equality = const DeepCollectionEquality();

  Tuple2(this.value1, this.value2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple2 &&
          runtimeType == other.runtimeType &&
          _equality.equals(value1, other.value1) &&
          _equality.equals(value2, other.value2);

  @override
  int get hashCode => _equality.hash(value1) ^ _equality.hash(value2);

  @override
  String toString() {
    return 'Tuple2{value1: $value1, value2: $value2}';
  }
}
