import 'dart:async' show Stream, StreamController;
import 'package:meta/meta.dart' show mustCallSuper;

class ValueStream<T> {
  /// Criar uma instância `StreamController` e sua propriedades
  /// Este objeto pode se combinado o widget `StreamBuilder` ou qualquer widget customizado que usa uma stream
  /// Ao usar esse objeto, devemos se atentar em chamar o método [dispose] quando o objeto não tiver utilidade
    
  final T _initialValue;

  ValueStream(this._initialValue){
    streamController.stream.listen((value) {
      _dataValue = value;
    });
  }

  final StreamController<T> streamController = StreamController<T>.broadcast();
  Sink<T> get sink => streamController.sink;//input
  Stream<T> get stream => streamController.stream;//output

  T? _dataValue;
 
  T get value => _dataValue ?? _initialValue;

  set value(T newValue) => sink.add(newValue);

  @mustCallSuper
  void dispose() {
    sink.close();
    streamController.close();
  }

}

abstract class DisposeValueStream{
  void dispose(){}
}