## Ephemeral state manager
A package é um gerenciamento de estado [efêmero](https://docs.flutter.dev/development/data-and-backend/state-mgmt/ephemeral-vs-app) simples e objetivo (é um [estado](https://api.flutter.dev/flutter/widgets/State-class.html) temporário de uma widget), com essa package é possível usar o setState ou streamCotroller de forma segura indicando onde deve ser feito a build do widget multável sem re-buildar toda árvore de widget da página ativa exatamente como a documentação da framework recomenda.

- Não precisa usar annotations para indicar que é uma variável mutável ou observável
- Não precisa usar gerador de código
- É necessário disposar apenas as variáveis do tipo Streamcontroller. As que usam setState não precisam
- Segundo a documentação da framework, ao usarmos um widget com um valor mutável totalmente isolada, que re-builda apenas o necessário, temos uma performance mais [otimizada]( https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html#performance-considerations) na renderização dos componentes da árvore de widgets

## Exemplo de uso
```dart
import 'package:flutter/material.dart';
import 'package:ephemeral_state_manager/src/stateSetterBuilder.dart';

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

  final Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    print('Create HomaPage build');
    return Scaffold(
      appBar: AppBar(title: Text('Exemplo de uso StateSetterBuilder')),
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
```