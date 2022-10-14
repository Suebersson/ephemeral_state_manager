import 'package:flutter/widgets.dart';

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
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.valueStateSetter.value);
}

class ValueState<T> {
  final T _initialValue;
  ValueState(this._initialValue);

  T? _dataValue;

  StateSetter? _setState;

  T get value => _dataValue ?? _initialValue;

  set value(T newValue) {
    if (_setState != null) {
      if (newValue != _dataValue) {
        _dataValue = newValue;
        _setState!(() => _dataValue);
      }
    } else {
      throw 'Não existe um estado para chamar a função setState';
    }
  }
}
