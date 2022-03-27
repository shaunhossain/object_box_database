import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:object_box_database/objectbox.g.dart';
import 'package:object_box_database/order_data_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final faker = Faker();
  late Store _store;

  @override
  void initState() {
    super.initState();
    setNewCustomer();
    getApplicationDocumentsDirectory().then((dir) {
      _store = Store(getObjectBoxModel(),directory: join(dir.path,'object_box'));
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            onPressed: setNewCustomer,
          ),
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: addFakeOrderForCurrentCustomer,
          ),
        ],
      ),
      body: OrderDataTable(
        // TODO: Pass in the orders
        onSort: (columnIndex, ascending) {
          // TODO: Query the database and sort the data
        },
      ),
    );
  }

  void setNewCustomer() {
    // TODO: Implement properly
    print('Name: ${faker.person.name()}');
  }

  void addFakeOrderForCurrentCustomer() {
    // TODO: Implement properly
    print('Price: ${faker.randomGenerator.integer(500, min: 10)}');
  }
}