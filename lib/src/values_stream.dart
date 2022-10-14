// ignore: implementation_imports
import 'package:dart_dev_utils/src/data_stream.dart' show DataStream;

class ValuesStream<T> extends DataStream<T> {
  ValuesStream(initialValue) : super(initialValue);
}

abstract class DisposeValuesStream {
  void dispose() {}
}
