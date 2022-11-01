import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:math';

import '../providers/orders_provider.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget(this.order, {super.key});

  final OrderItem order;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 100,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            title: Text('£${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 15, 100)
                : 0,
            child: ListView(
              children: widget.order.products
                  .map(
                    (prod) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          prod.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${prod.quantity} x £${prod.price}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        ]),
      ),
    );
  }
}
