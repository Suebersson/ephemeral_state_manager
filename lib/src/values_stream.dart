import 'package:dart_dev_utils/dart_dev_utils.dart' show DataStream;

class ValuesStream<T> extends DataStream<T> {
  ValuesStream(T initialValue) : super(initialValue);
  ValuesStream.broadcast(T initialValue) : super.broadcast(initialValue);
}
