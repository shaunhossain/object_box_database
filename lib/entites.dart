
import 'package:objectbox/objectbox.dart';

@Entity()
class ShopOrder{
  ShopOrder({ this.id = 0, required this.price});
  int id;
  int price;
  final customer = ToOne<Customer>();
}


@Entity()
class Customer{
  Customer({
    this.id = 0,
    required this.name,
  });
  int id;
  String name;
  final orders = ToMany<ShopOrder>();
}