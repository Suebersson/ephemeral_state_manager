import 'package:flutter/material.dart';
import 'package:ephemeral_state_manager/ephemeral_state_manager.dart';
import 'PageStateSetterBuilderKey.dart';

class PageStateSetterBuilder extends StatelessWidget {
  const PageStateSetterBuilder({Key? key, required this.controller})
      : super(key: key);

  final PageStateSetterBuilderController controller;

  @override
  Widget build(BuildContext context) {
    print('Create HomaPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageStateSetterBuilder: usando setState'),
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
              StateSetterBuilder<int>(
                  valueStateSetter: controller.counter,
                  builder: (context, value) {
                    print('Upadate: counter');
                    return Text(
                      '$value',
                      style: Theme.of(context).textTheme.headline4,
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
                  return PageStateSetterBuilderKey(
                      controller: PageStateSetterBuilderKeyController());
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
                'StateSetterBuilderKey',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageStateSetterBuilderController {
  final ValueState<int> counter = ValueState<int>(0);

  void increment() => counter.value++;

  void decrement() => counter.value--;
}
