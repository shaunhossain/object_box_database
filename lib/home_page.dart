import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:object_box_database/entites.dart';
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
  bool hasBeenInitialized = false;

  late Customer _customer;
  late Stream<List<ShopOrder>> _stream;

  @override
  void initState() {
    super.initState();
    setNewCustomer();
    getApplicationDocumentsDirectory().then((dir) {
      _store = Store(
        getObjectBoxModel(),
        directory: join(dir.path, 'object_box'),
      );

      setState(() {
        _stream = _store
            .box<ShopOrder>()
        // The simplest possible query that just gets ALL the data out of the Box
            .query()
            .watch(triggerImmediately: true)
        // Watching the query produces a Stream<Query<ShopOrder>>
        // To get the actual data inside a List<ShopOrder>, we need to call find() on the query
            .map((query) => query.find());

        hasBeenInitialized = true;
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setNewCustomer();
  //   openStore().then((Store store) {
  //     _store = store;
  //   });
  //   // getApplicationDocumentsDirectory().then((dir) {
  //   //   _store = Store(getObjectBoxModel(),directory: join(dir.path,'object_box'));
  //   // });
  //   setState(() {
  //     hasBeenInitialized = true;
  //     _stream = _store.box<ShopOrder>().query().watch(triggerImmediately: true).map((query) =>query.find());
  //   });
  // }

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
      body: !hasBeenInitialized ? const Center(child: CircularProgressIndicator(),) : StreamBuilder<List<ShopOrder>>(
        stream: _stream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }
          return OrderDataTable(
            orders: snapshot.data!,
            onSort: (columnIndex, ascending) {
              // TODO: Query the database and sort the data
            },
          );
        }
      ),
    );
  }

  void setNewCustomer() {
    _customer = Customer(name: faker.person.name());
  }

  void addFakeOrderForCurrentCustomer() {
    final order = ShopOrder(
      price: faker.randomGenerator.integer(500, min: 10),
    );
    order.customer.target = _customer;
    _store.box<ShopOrder>().put(order);
  }
}