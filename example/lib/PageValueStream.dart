import 'package:flutter/material.dart';
import 'package:ephemeral_state_manager/ephemeral_state_manager.dart';

import './pageValueStreamWillPopScope.dart';

class PageValueStream extends StatefulWidget {
  const PageValueStream({Key? key}) : super(key: key);

  @override
  State<PageValueStream> createState() => _HomePageState();
}

class _HomePageState extends State<PageValueStream> {
  final PageValueStreamController controller = PageValueStreamController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Create HomaPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageValueStream: usando StreamController'),
      ),
      body: Column(
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
                builder: (context, snapshot) {
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return PageValueStreamWillPopScope(controller: PageValueStreamWillPopScopeController());
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
                'PageValueStreamWillPopScope',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageValueStreamController implements DisposeValuesStream {
  final ValuesStream<int> counter = ValuesStream<int>(0);

  void incrementCounter() => counter.value++;
  void decrementCounter() => counter.value--;

  @override
  void dispose() => counter.dispose();
}
