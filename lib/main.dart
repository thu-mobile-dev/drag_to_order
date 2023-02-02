import "package:flutter/material.dart";
import "package:drag_to_order/model.dart";

void main() {
  runApp(
    MaterialApp(
      home: FoodStallOrderMenu(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class FoodStallOrderMenu extends StatelessWidget {
  FoodStallOrderMenu({super.key});

  final GlobalKey draggableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: ItemsView(items: test_items, draggableKey: draggableKey),
          ),
          CustomersView(
            customers: test_customers,
          ),
        ],
      ),
    );
  }
}

// Item

class ItemsView extends StatelessWidget {
  const ItemsView({super.key, required this.items, required this.draggableKey});

  final List<Item> items;
  final GlobalKey draggableKey;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12.0,
        );
      },
      itemBuilder: (context, index) {
        final item = items[index];
        return DraggableItemView(
          item: item,
          draggableKey: draggableKey,
        );
      },
    );
  }
}

class DraggableItemView extends StatelessWidget {
  const DraggableItemView(
      {super.key, required this.item, required this.draggableKey});

  final Item item;
  final GlobalKey draggableKey;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Item>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingItemView(
        dragKey: draggableKey,
        photoProvider: item.image,
      ),
      child: ItemView(
        name: item.name,
        price: item.priceString,
        photoProvider: item.image,
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  const ItemView({
    super.key,
    this.name = "",
    this.price = "",
    required this.photoProvider,
    this.isDepressed = false,
  });

  final String name;
  final String price;
  final ImageProvider photoProvider;
  final bool isDepressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 115 : 120,
                    width: isDepressed ? 115 : 120,
                    child: Image(
                      image: photoProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 24.0,
                        ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingItemView extends StatelessWidget {
  const DraggingItemView({
    super.key,
    required this.dragKey,
    required this.photoProvider,
  });

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

// Customer

class CustomersView extends StatelessWidget {
  const CustomersView({super.key, required this.customers});

  final List<Customer> customers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 20.0,
      ),
      child: Row(
        children: customers.map((customer) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
              ),
              child: DroppableCustomerView(customer: customer),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DroppableCustomerView extends StatelessWidget {
  const DroppableCustomerView({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Item>(
      builder: (context, candidateItems, rejectedItems) {
        return CustomerView(
          hasItems: customer.items.isNotEmpty,
          highlighted: candidateItems.isNotEmpty,
          customer: customer,
        );
      },
      onAccept: (item) {
        customer.items.add(item);
      },
    );
  }
}

class CustomerView extends StatelessWidget {
  const CustomerView({
    super.key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  });

  final Customer customer;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: highlighted ? 8.0 : 4.0,
        borderRadius: BorderRadius.circular(22.0),
        color: highlighted ? const Color(0xFF6BD3A4) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Image(
                    image: customer.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                customer.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4.0),
              Text(
                customer.totalPriceString,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4.0),
              Text(
                hasItems ? "共 ${customer.items.length} 份" : "未点餐",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: textColor,
                      fontSize: 12.0,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
