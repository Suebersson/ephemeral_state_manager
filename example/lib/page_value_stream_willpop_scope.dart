import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart' show Disposeble;
import 'package:ephemeral_state_manager/ephemeral_state_manager.dart';

/// Exemplo de uma página que discarta[dispose] a controller[Stream] sem usar uma [StatefulWidget]
/// basta usar o widget [WillPopScope]
class PageValueStreamWillPopScope extends StatelessWidget {
  const PageValueStreamWillPopScope({Key? key, required this.controller}) : super(key: key);
  
  final PageValueStreamWillPopScopeController controller;

  @override
  Widget build(BuildContext context) {
    print('Create HomaPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageValueStream: usando StreamController'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), 
          onPressed: (){
            Navigator.maybePop(context);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async{
          print('---- controller disposed ----');
          controller.dispose();
          return true;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.exposure_neg_1,
                    size: 45.0,
                    color: Colors.red,
                  ),
                  onPressed: controller.decrementCounter,
                ),
                StreamBuilder<int>(
                  stream: controller.counter.stream,
                  initialData: controller.counter.value,
                  builder: (context, snapshot){
                    print('Upadate: ${snapshot.data}');
                    return Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.exposure_plus_1,
                      size: 45.0, color: Colors.red),
                  onPressed: controller.incrementCounter,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Está página(StatelessWidget) usa o widget WillPopScope para disposar a controller sem precisar uma StatefulWidget'
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageValueStreamWillPopScopeController extends Disposeble {

  final ValuesStream<int> counter = ValuesStream<int>(0);

  void incrementCounter() => counter.value++;
  void decrementCounter() => counter.value--;

  @override
  void dispose() => counter.dispose();

}
