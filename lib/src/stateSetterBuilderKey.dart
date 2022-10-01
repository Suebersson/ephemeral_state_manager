import 'package:flutter/widgets.dart';

/// O nome [StateSetterBuilderKey] significa que é um widget do tipo [StatefulWidget], que re-builda
/// o widget usando a função do tipo [StateSetter] ou pelo nome mais popular [setState] 
/// usanso um chave de identificação
///
/// Esse gerenciamento de estado é bem simples e objetivo, é basicamente uma forma de usar o [setState]
/// com precisão, indicando onde deve ser feita a atualização apenas do Widget multavel sem re-buildar 
/// toda árvore de widget da página ativa exatamente como a documentação da framework recomenda ao 
/// usarmos widgets [StatefulWidget]
/// https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html#performance-considerations
/// https://flutter.dev/docs/perf/rendering/best-practices#controlling-build-cost
/// https://api.flutter.dev/flutter/widgets/State-class.html
/// 
/// Os componentes usados para compor esse recurso são:
/// - Uma Widget [StatefulWidget]
/// - Uma variável [Map] combinada com valores do tipo [String] e [StateSetter](setState)
/// - Uma classe abstrata responsável por chamar o [StateSetter] para atualizar o widget através da sua chave 
/// 
/// Vantagens:
/// - Não precisa usar annotations para indicar que é uma variável mutavel ou observavel
/// - Não precisa usar gerador de código
/// - Não precisa usar variáveis do tipo controller que precisam ser fechadas ou disposadas
/// - Segundo a documentação da framework, ao usarmos um widget com um valor mutavel totalmente isolada, que
///   re-builda apenas o necessário, temos uma performace mais otimizada na renderização dos
///   componentes da árvore de widgets

@immutable
class StateSetterBuilderKey<T> extends StatefulWidget {
  /// Criar um widget mutavel que será atulizado através 
  /// de uma função [StateSetter] ou [setState] sem re-buildar toda árvore de widgets
  /// 
  /// Este widget pode ser usado tanto para controle de gerenciamento de [Estado efêmero](estado passageiro ou temporário)
  /// quanto para gerenciamento de [Estado do aplicativo](estado com dependências fixas)
  /// Para mais informações acesse: 
  /// https://flutter.dev/docs/development/data-and-backend/state-mgmt/ephemeral-vs-app
  final T objectInstance;
  final String stateSetterKey;
  final Widget Function(BuildContext, T) builder;
  const StateSetterBuilderKey({
    Key? key,
    required this.objectInstance,
    required this.stateSetterKey,
    required this.builder,
  }): super(key: key);

  @override
  _StateSetterBuilderKeyState<T> createState() => _StateSetterBuilderKeyState<T>();
}

class _StateSetterBuilderKeyState<T> extends State<StateSetterBuilderKey<T>> {

  @override
  void initState() {
    super.initState();
    /// adicionando a chave [String] e a função [setState] na variável [stateSetters] 
    if(!StateSetterValues._stateSetters.containsKey(widget.stateSetterKey)){
      StateSetterValues._stateSetters[widget.stateSetterKey] = super.setState;
    }else{
      throw "Chave já existente";
    }
  }

  @override
  void dispose() {
    /// Removendo a [stateSetterKey] e a [StateSetter]
    StateSetterValues._stateSetters.remove(widget.stateSetterKey);
    //print('----- stateSetterKey: ${widget.stateSetterKey} has been removed -----');
    super.dispose();
  }

  /*@override
  void didUpdateWidget(StateSetterBuilderKey oldWidget) {
    super.didUpdateWidget(oldWidget as StateSetterBuilderKey<T>);
  }*/

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.objectInstance);

}

abstract class StateSetterValues{

  //Map responsável por armazenar todas as chave e setState
  static final Map<String, StateSetter> _stateSetters = {};

  //Método responsável por chamar a VoidCallback do setState
  @mustCallSuper
  @protected
  @visibleForTesting
  void updateValue<T>({required String stateSetterKey, required T data}){
    if(_stateSetters.containsKey(stateSetterKey)){
      _stateSetters[stateSetterKey]!(() => data); //return the updated value
    }else{
      throw "A chave de atualização para chamar a função StateSetter não foi encontrada";
    }
  }

}