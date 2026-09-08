import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Product {
  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.color,
    required this.icon,
    required this.tag,
    required this.imageAsset,
  });
  final String name, category, tag;
  final double price, rating;
  final Color color;
  final IconData icon;
  final String imageAsset;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Luma Shop',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6c4cf5)),
    ),
    home: const ProductCatalogPage(),
  );
}

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});
  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  final search = TextEditingController();
  String query = '', category = 'All';
  final cartItems = <String, int>{};
  bool favoritesOnly = false;
  final favorites = <String>{};
  int get cartCount =>
      cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  final products = const [
    Product(
      name: 'Orbit Headphones',
      category: 'Audio',
      price: 129,
      rating: 4.8,
      color: Color(0xffc4b5fd),
      icon: Icons.headphones_rounded,
      tag: 'Bestseller',
      imageAsset: 'assets/images/orbit-headphones.png',
    ),
    Product(
      name: 'Pixel Watch',
      category: 'Wearables',
      price: 189,
      rating: 4.6,
      color: Color(0xfffbbf77),
      icon: Icons.watch_rounded,
      tag: 'New drop',
      imageAsset: 'assets/images/pixel-watch.png',
    ),
    Product(
      name: 'Flow Speaker',
      category: 'Audio',
      price: 89,
      rating: 4.7,
      color: Color(0xff86efac),
      icon: Icons.speaker_rounded,
      tag: 'Popular',
      imageAsset: 'assets/images/flow-speaker.png',
    ),
    Product(
      name: 'Nova Camera',
      category: 'Tech',
      price: 249,
      rating: 4.9,
      color: Color(0xfff9a8d4),
      icon: Icons.camera_alt_rounded,
      tag: "Editor's pick",
      imageAsset: 'assets/images/nova-camera.png',
    ),
    Product(
      name: 'Cloud Keyboard',
      category: 'Tech',
      price: 74,
      rating: 4.5,
      color: Color(0xff7dd3fc),
      icon: Icons.keyboard_rounded,
      tag: 'Limited',
      imageAsset: 'assets/images/cloud-keyboard.png',
    ),
    Product(
      name: 'Terra Bottle',
      category: 'Lifestyle',
      price: 32,
      rating: 4.8,
      color: Color(0xffa7f3d0),
      icon: Icons.water_drop_rounded,
      tag: 'Planet kind',
      imageAsset: 'assets/images/terra-bottle.png',
    ),
  ];
  List<Product> get filtered =>
      products
          .where(
            (p) =>
                (category == 'All' || p.category == category) &&
                ('${p.name} ${p.category} ${p.tag}').toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .where((p) => !favoritesOnly || favorites.contains(p.name))
          .toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const categories = ['All', 'Audio', 'Wearables', 'Tech', 'Lifestyle'];
    final shown = filtered;
    return Scaffold(
      backgroundColor: const Color(0xfff8f7fc),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LUMA',
                          style: TextStyle(
                            letterSpacing: 3,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Color(0xff6c4cf5),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Find your next favorite',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: openCart,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Badge(
                        isLabelVisible: cartCount > 0,
                        label: Text('$cartCount'),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: search,
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: 'Search the good stuff...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            search.clear();
                            setState(() => query = '');
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final item = categories[i];
                  final selected = item == category;
                  return ChoiceChip(
                    label: Text(item),
                    selected: selected,
                    onSelected: (_) => setState(() => category = item),
                    selectedColor: const Color(0xff6c4cf5),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : const Color(0xff4b4758),
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide.none,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
              child: Row(
                children: [
                  Text(
                    '${shown.length} curated finds',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Show saved items',
                    visualDensity: VisualDensity.compact,
                    onPressed: () =>
                        setState(() => favoritesOnly = !favoritesOnly),
                    icon: Icon(
                      favoritesOnly
                          ? Icons.favorite_rounded
                          : Icons.tune_rounded,
                      color: favoritesOnly ? const Color(0xffef5c83) : null,
                    ),
                  ),
                  Text(
                    favoritesOnly ? 'Saved' : 'Top rated',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Expanded(
              child: shown.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.travel_explore_rounded,
                            size: 62,
                            color: Color(0xffb7afd8),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Nothing found yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text('Try another search or category.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: shown.length + 1,
                      itemBuilder: (_, i) =>
                          i == 0 ? heroCard() : card(shown[i - 1]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget heroCard() => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          SizedBox(
            height: 142,
            width: double.infinity,
            child: Image.asset(
              'assets/images/luma-collection.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          Container(
            height: 142,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xdd302950), Color(0x00302950)],
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 19,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'THE WEEKEND EDIT',
                  style: TextStyle(
                    color: Color(0xffd8ccff),
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Small things.\nBig delight.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => setState(() => category = 'Audio'),
                  child: const Text(
                    'Explore audio →',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget card(Product p) {
    final liked = favorites.contains(p.name);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => sheet(p),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 96,
                  height: 104,
                  decoration: BoxDecoration(
                    color: p.color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          p.imageAsset,
                          width: 96,
                          height: 104,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            p.tag,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Color(0xff81799c),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xffffb526),
                            size: 17,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${p.rating}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(
                    () => liked
                        ? favorites.remove(p.name)
                        : favorites.add(p.name),
                  ),
                  icon: Icon(
                    liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: liked
                        ? const Color(0xffef5c83)
                        : const Color(0xff6e687d),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openCart() => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CartPage(
        products: products,
        cartItems: cartItems,
        onChanged: () => setState(() {}),
      ),
    ),
  );

  void sheet(Product p) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'A thoughtfully selected ${p.category.toLowerCase()} essential, made to brighten your everyday.',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () {
              Navigator.pop(sheetContext);
              setState(
                () => cartItems.update(
                  p.name,
                  (quantity) => quantity + 1,
                  ifAbsent: () => 1,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${p.name} added to your bag!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: Text('Add to bag · ₹${p.price.toStringAsFixed(0)}'),
          ),
        ],
      ),
    ),
  );
}

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
    required this.products,
    required this.cartItems,
    required this.onChanged,
  });
  final List<Product> products;
  final Map<String, int> cartItems;
  final VoidCallback onChanged;
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> get items => widget.products
      .where((p) => widget.cartItems.containsKey(p.name))
      .toList();
  double get subtotal =>
      items.fold(0, (total, p) => total + p.price * widget.cartItems[p.name]!);

  void change(Product product, int delta) {
    setState(() {
      final next = widget.cartItems[product.name]! + delta;
      if (next == 0) {
        widget.cartItems.remove(product.name);
      } else {
        widget.cartItems[product.name] = next;
      }
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xff6c4cf5);
    final delivery = subtotal == 0 || subtotal >= 150 ? 0.0 : 12.0;
    return Scaffold(
      backgroundColor: const Color(0xfff8f7fc),
      appBar: AppBar(
        backgroundColor: const Color(0xfff8f7fc),
        title: const Text(
          'Your bag',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: false,
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Color(0xffb7afd8),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Your bag is waiting',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  Text('Add something that sparks joy.'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    itemCount: items.length + 1,
                    itemBuilder: (_, index) {
                      if (index == items.length) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: purple,
                              ),
                              SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  'Free delivery on orders over ₹150',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final p = items[index];
                      final quantity = widget.cartItems[p.name]!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    p.imageAsset,
                                    width: 76,
                                    height: 76,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '₹${p.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: purple,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 9),
                                      Row(
                                        children: [
                                          IconButton(
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () => change(p, -1),
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          IconButton(
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () => change(p, 1),
                                            icon: const Icon(
                                              Icons.add_circle,
                                              color: purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => change(p, -quantity),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xff8c849a),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      _row('Subtotal', subtotal),
                      _row('Delivery', delivery),
                      const Divider(height: 24),
                      _row('Total', subtotal + delivery, bold: true),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: purple,
                          minimumSize: const Size.fromHeight(54),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            icon: const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xff24a16f),
                              size: 42,
                            ),
                            title: const Text('Order ready!'),
                            content: const Text(
                              'This is a demo checkout — your beautiful picks are saved in the bag.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Continue shopping'),
                              ),
                            ],
                          ),
                        ),
                        icon: const Icon(Icons.lock_outline),
                        label: Text(
                          'Checkout · ₹${(subtotal + delivery).toStringAsFixed(0)}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _row(String label, double amount, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
            fontSize: bold ? 18 : 14,
          ),
        ),
        const Spacer(),
        Text(
          amount == 0 && label == 'Delivery'
              ? 'Free'
              : '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            fontSize: bold ? 18 : 14,
            color: label == 'Delivery' && amount == 0
                ? const Color(0xff24a16f)
                : null,
          ),
        ),
      ],
    ),
  );
}
