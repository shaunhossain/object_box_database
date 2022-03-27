import 'package:flutter/material.dart';
import 'package:object_box_database/entites.dart';

class OrderDataTable extends StatefulWidget {
  final void Function(int columnIndex, bool ascending) onSort;
  final List<ShopOrder> orders;

  const OrderDataTable({
    Key? key,
    required this.onSort, required this.orders,
  }) : super(key: key);

  @override
  _OrderDataTableState createState() => _OrderDataTableState();
}

class _OrderDataTableState extends State<OrderDataTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            DataColumn(
              label: const Text('ID'),
              onSort: _onDataColumnSort,
            ),
            const DataColumn(
              label: Text('Customer'),
            ),
            DataColumn(
              label: const Text('Price'),
              numeric: true,
              onSort: _onDataColumnSort,
            ),
            DataColumn(
              label: Container(),
            ),
          ],
          rows: widget.orders.map((order) {
            return DataRow(
              cells: [
                 DataCell(
                  Text(order.id.toString()),
                ),
                DataCell(
                  Text(order.customer.target?.name ?? 'None'),
                  onTap: () {
                    // TODO: Show only tapped customer's orders in a modal bottom sheet
                  },
                ),
                DataCell(
                  Text(
                    '\$${order.price.toString()}',
                  ),
                ),
                DataCell(
                  const Icon(Icons.delete),
                  onTap: () {
                    // TODO: Delete the order from the database
                  },
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onDataColumnSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }
}