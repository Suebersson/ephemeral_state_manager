import 'package:flutter/material.dart';
import 'package:ephemeral_state_manager/ephemeral_state_manager.dart';
import 'page_value_stream.dart';

class PageStateSetterBuilderKey extends StatelessWidget {
  const PageStateSetterBuilderKey({Key? key, required this.controller})
      : super(key: key);

  final PageStateSetterBuilderKeyController controller;

  @override
  Widget build(BuildContext context) {
    //print('Create HomaPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageStateSetterBuilderKey: usando setState'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.exposure_neg_1,
                    size: 45.0, color: Colors.red),
                onPressed: controller.decrement,
              ),
              StateSetterBuilderKey<PageStateSetterBuilderKeyController>(
                objectInstance: controller,
                stateSetterKey: "counter",
                builder: (context, object) {
                  //print('Upadate key: counter');
                  return Text(
                    '${object.counter}',
                    //'${controller.counter}', //as duas formas funcionam
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }
              ),
              IconButton(
                icon: const Icon(Icons.exposure_plus_1,
                    size: 45.0, color: Colors.red),
                onPressed: controller.increment,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const PageValueStream();
                }),
              );
            },
            child: Container(
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
              margin: const EdgeInsets.only(top: 60),
              height: 50,
              width: 300,
              child: const Text(
                'PageValueStream',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageStateSetterBuilderKeyController extends StateSetterValues {
  int counter = 0;

  void increment() =>
      super.updateValue(stateSetterKey: "counter", data: counter++);

  void decrement() =>
      super.updateValue(stateSetterKey: "counter", data: counter--);
}
