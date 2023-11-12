import 'package:flutter/widgets.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart' show printLog;

/// O nome [StateSetterBuilder] significa que é um widget do tipo [StatefulWidget], que re-builda
/// o widget usando a função do tipo [StateSetter] ou pelo nome mais popular [setState]
///
/// Esse gerenciamento de estado é bem simples e objetivo, é basicamente uma forma
/// de chamar a função [setState] com precisão, indicando onde deve ser feita
/// a atualização apenas do Widget que usa um valor
/// multavel sem re-buildar toda árvore de widget da página ativa exatamente como a documentação
///  da framework recomenda ao usarmos widgets [StatefulWidget]
/// https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html#performance-considerations
/// https://flutter.dev/docs/perf/rendering/best-practices#controlling-build-cost
/// https://api.flutter.dev/flutter/widgets/State-class.html
///
/// Vantagens:
/// - Não precisa usar annotations para indicar que é uma variável mutável ou observavel
/// - Não precisa usar gerador de código
/// - Não precisa usar variáveis do tipo controller que precisam ser fechadas ou disposadas
/// - Segundo a documentação da framework, ao usarmos um widget com um valor mutável totalmente isolada, que
///   re-builda apenas o necessário, temos uma performace mais otimizada na renderização dos
///   componentes da árvore de widgets

@immutable
class StateSetterBuilder<T> extends StatefulWidget {
  /// Criar um widget mutável que será atulizado através
  /// de uma função [StateSetter] ou [setState] sem re-buildar toda árvore de widgets
  ///
  /// Este widget pode ser usado tanto para controle de gerenciamento de [Estado efêmero](estado passageiro ou temporário)
  /// quanto para gerenciamento de [Estado do aplicativo](estado com dependências fixas)
  /// Para mais informações acesse:
  /// https://flutter.dev/docs/development/data-and-backend/state-mgmt/ephemeral-vs-app
  final ValueState valueStateSetter;
  final Widget Function(BuildContext, T) builder;
  const StateSetterBuilder(
      {Key? key, required this.valueStateSetter, required this.builder})
      : super(key: key);

  @override
  _StateSetterBuilderState<T> createState() => _StateSetterBuilderState<T>();
}

class _StateSetterBuilderState<T> extends State<StateSetterBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.valueStateSetter._setState = super.setState;
  }

  @override
  void dispose() {
    widget.valueStateSetter._setState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.valueStateSetter.value);
}

class ValueState<T> {
  ValueState(this._initialValue, {this.rebuildEqualValue = false});

  final T _initialValue;

  /// rebuildar a widget se o novo valor igual ao valor anterior
  final bool rebuildEqualValue;

  T? _currentValue;

  StateSetter? _setState;

  T get value => _currentValue ?? _initialValue;

  set value(T newValue) {
    if (_setState is StateSetter) {
      if (newValue != _currentValue) {
        _setState!(() => _currentValue = newValue);
      } else if (rebuildEqualValue) {
        _setState!(() => _currentValue = newValue);
      }
    } else {
      _notification();
    }
  }

  void update() {
    if (_setState is StateSetter) {
      _setState!(
        () {},
      );
    } else {
      _notification();
    }
  }

  void _notification() {
    printLog(
      'Não existe um estado para chamar a função setState',
      name: '$runtimeType',
    );
  }
}

// Exemplo de uso
/*
import 'package:flutter/material.dart';
import './ephemeralStateManager/stateSetterBuilder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App",
      theme: ThemeData(primaryColor: Colors.indigo),
      home: HomePage(),    
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    final Controller controller = Controller();

    print('Create HomaPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo de uso StateSetterBuilder')
      ),
      body: Center(
        child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             IconButton(
               icon: Icon(Icons.exposure_neg_1, size: 45.0, color: Theme.of(context).primaryColor), 
               onPressed: controller.decrement,
             ),
             StateSetterBuilder<int>(
               valueStateSetter: controller.counter,
               builder: (context, value){
                 print('Upadate: counter');
                 return Text(
                   '$value',
                   style: Theme.of(context).textTheme.headline4,
                 );
               }
             ),
             IconButton(
               icon: Icon(Icons.exposure_plus_1, size: 45.0, color: Theme.of(context).primaryColor), 
               onPressed: controller.increment,
             ),
           ],
         ),
      ),
    );
  }
}

class Controller {

  final ValueState<int> counter = ValueState<int>(0);

  void increment() => counter.value++;

  void decrement() => counter.value--;

}
*/
