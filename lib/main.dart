import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const _ink = Color(0xff111111);
const _panel = Color(0xff1a1a1a);
const _cream = Color(0xfff4efe6);
const _gold = Color(0xffc4a574);
const _muted = Color(0xff8a8478);

const _serif = TextStyle(
  fontFamily: 'Georgia',
  color: _cream,
  fontFamilyFallback: ['serif', 'Times New Roman'],
);

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
    title: 'Luma',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _ink,
      visualDensity: VisualDensity.standard,
      colorScheme: const ColorScheme.dark(
        primary: _cream,
        secondary: _gold,
        surface: _panel,
        onPrimary: _ink,
        onSurface: _cream,
      ),
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
      name: 'Wool Coat',
      category: 'Outer',
      price: 8900,
      rating: 4.8,
      color: Color(0xff2a2420),
      icon: Icons.checkroom_rounded,
      tag: 'Bestseller',
      imageAsset: 'assets/images/wool-coat.png',
    ),
    Product(
      name: 'Silk Shirt',
      category: 'Tops',
      price: 3200,
      rating: 4.6,
      color: Color(0xff3a322c),
      icon: Icons.checkroom_outlined,
      tag: 'New drop',
      imageAsset: 'assets/images/silk-shirt.png',
    ),
    Product(
      name: 'Wide Trousers',
      category: 'Trousers',
      price: 4100,
      rating: 4.7,
      color: Color(0xff1c1c1c),
      icon: Icons.dry_cleaning_rounded,
      tag: 'Popular',
      imageAsset: 'assets/images/wide-trousers.png',
    ),
    Product(
      name: 'Leather Belt',
      category: 'Accessories',
      price: 1650,
      rating: 4.5,
      color: Color(0xff4a3a28),
      icon: Icons.watch_rounded,
      tag: 'Limited',
      imageAsset: 'assets/images/leather-belt.png',
    ),
    Product(
      name: 'Cashmere Knit',
      category: 'Tops',
      price: 5400,
      rating: 4.9,
      color: Color(0xff3d3428),
      icon: Icons.texture_rounded,
      tag: "Editor's pick",
      imageAsset: 'assets/images/cashmere-knit.png',
    ),
    Product(
      name: 'Linen Overshirt',
      category: 'Outer',
      price: 3800,
      rating: 4.4,
      color: Color(0xff2a3028),
      icon: Icons.layers_rounded,
      tag: 'Planet kind',
      imageAsset: 'assets/images/linen-overshirt.png',
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

  EdgeInsets get _gutter {
    final w = MediaQuery.sizeOf(context).width;
    final side = w >= 1100
        ? 64.0
        : w >= 700
        ? 32.0
        : 20.0;
    return EdgeInsets.symmetric(horizontal: side);
  }

  int columnsFor(double width) {
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    const categories = ['All', 'Outer', 'Tops', 'Trousers', 'Accessories'];
    final shown = filtered;
    final width = MediaQuery.sizeOf(context).width;
    final columns = columnsFor(width);
    final rows = shown.isEmpty ? 0 : (shown.length / columns).ceil();
    final itemCount = 2 + (shown.isEmpty ? 1 : rows);

    return Scaffold(
      backgroundColor: _ink,
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (_, i) {
          if (i == 0) return siteTop(categories, shown.length);
          if (shown.isEmpty) {
            return i == 1 ? emptyState() : siteFooter();
          }
          if (i == rows + 1) return siteFooter();
          return productRow(shown, columns, i - 1);
        },
      ),
    );
  }

  Widget siteTop(List<String> categories, int count) {
    final wide = MediaQuery.sizeOf(context).width >= 860;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff2a2a2a))),
          ),
          padding: _gutter.copyWith(top: 18, bottom: 18),
          child: wide
              ? Row(
                  children: [
                    const Text(
                      'LUMA',
                      style: TextStyle(
                        letterSpacing: 5,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: _gold,
                      ),
                    ),
                    const SizedBox(width: 36),
                    Expanded(child: navTabs(categories)),
                    SizedBox(width: 280, child: searchField()),
                    const SizedBox(width: 16),
                    bagButton(),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'LUMA',
                          style: TextStyle(
                            letterSpacing: 5,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: _gold,
                          ),
                        ),
                        const Spacer(),
                        bagButton(),
                      ],
                    ),
                    const SizedBox(height: 14),
                    searchField(),
                    const SizedBox(height: 14),
                    navTabs(categories),
                  ],
                ),
        ),
        Padding(
          padding: _gutter.copyWith(top: 48, bottom: 36),
          child: heroCopy(),
        ),
        Padding(
          padding: _gutter.copyWith(bottom: 20),
          child: Row(
            children: [
              Text(
                '$count pieces',
                style: const TextStyle(
                  color: _muted,
                  letterSpacing: 0.8,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => setState(() => favoritesOnly = !favoritesOnly),
                icon: Icon(
                  favoritesOnly ? Icons.favorite_rounded : Icons.tune_rounded,
                  color: favoritesOnly ? _gold : _muted,
                  size: 18,
                ),
                label: Text(
                  favoritesOnly ? 'Saved' : 'Top rated',
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget heroCopy() => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Quiet cloth.',
        style: TextStyle(
          fontFamily: 'Georgia',
          fontFamilyFallback: ['serif', 'Times New Roman'],
          fontSize: 56,
          height: 0.95,
          color: _cream,
        ),
      ),
      SizedBox(height: 16),
      SizedBox(
        width: 460,
        child: Text(
          'A small collection of coats, shirts, and trousers — cut to be worn often, and well. Browse, search, and filter the rack.',
          style: TextStyle(color: _muted, height: 1.55, fontSize: 15),
        ),
      ),
    ],
  );

  Widget navTabs(List<String> categories) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final item in categories)
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: InkWell(
              onTap: () => setState(() => category = item),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  item.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                    color: item == category ? _cream : _muted,
                    decoration: item == category
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: _cream,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Widget searchField() => TextField(
    controller: search,
    onChanged: (v) => setState(() => query = v),
    cursorColor: _gold,
    style: const TextStyle(color: _cream, fontSize: 14),
    decoration: InputDecoration(
      hintText: 'Search coats, shirts, trousers',
      hintStyle: const TextStyle(color: _muted, fontSize: 14),
      prefixIcon: const Icon(Icons.search, color: _muted, size: 20),
      suffixIcon: query.isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.close, color: _muted, size: 18),
              onPressed: () {
                search.clear();
                setState(() => query = '');
              },
            ),
      filled: true,
      fillColor: _panel,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: Color(0xff3a3a3a)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(color: _cream),
      ),
    ),
  );

  Widget bagButton() => InkWell(
    onTap: openCart,
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Badge(
        backgroundColor: _gold,
        textColor: _ink,
        isLabelVisible: cartCount > 0,
        label: Text('$cartCount'),
        child: const Icon(Icons.shopping_bag_outlined, size: 24, color: _cream),
      ),
    ),
  );

  Widget emptyState() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 72),
    child: Column(
      children: [
        Icon(Icons.checkroom_outlined, size: 56, color: Color(0xff3a3a3a)),
        SizedBox(height: 14),
        Text(
          'Nothing in the rack',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontFamilyFallback: ['serif', 'Times New Roman'],
            fontSize: 22,
            color: _cream,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Try another search or category.',
          style: TextStyle(color: _muted),
        ),
      ],
    ),
  );

  Widget productRow(List<Product> shown, int columns, int row) {
    return Padding(
      padding: _gutter.copyWith(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(columns, (c) {
          final index = row * columns + c;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: c == 0 ? 0 : 10,
                right: c == columns - 1 ? 0 : 10,
              ),
              child: index < shown.length
                  ? tile(shown[index])
                  : const SizedBox(),
            ),
          );
        }),
      ),
    );
  }

  Widget siteFooter() => Container(
    margin: const EdgeInsets.only(top: 24),
    padding: _gutter.copyWith(top: 28, bottom: 36),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xff2a2a2a))),
    ),
    child: const Row(
      children: [
        Text(
          'LUMA',
          style: TextStyle(letterSpacing: 3, fontSize: 11, color: _gold),
        ),
        Spacer(),
        Text(
          'Editorial apparel · Demo storefront',
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    ),
  );

  Widget tile(Product p) {
    final liked = favorites.contains(p.name);
    return InkWell(
      onTap: () => openProduct(p),
      mouseCursor: SystemMouseCursors.click,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: ColoredBox(
              color: p.color,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    p.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        p.icon,
                        size: 36,
                        color: _cream.withValues(alpha: 0.28),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Text(
                      p.tag.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: _cream,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: IconButton(
                      onPressed: () => setState(
                        () => liked
                            ? favorites.remove(p.name)
                            : favorites.add(p.name),
                      ),
                      icon: Icon(
                        liked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: liked ? _gold : _cream,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            p.category.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              color: _muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(p.name, style: _serif.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            '₹${p.price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
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

  void openProduct(Product p) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    if (!wide) {
      showSheet(p);
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: _panel,
        shape: const RoundedRectangleBorder(),
        child: SizedBox(
          width: 760,
          height: 440,
          child: Row(
            children: [
              Expanded(
                child: Image.asset(
                  p.imageAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      ColoredBox(color: p.color),
                ),
              ),
              Expanded(child: productCopy(p, dialogContext)),
            ],
          ),
        ),
      ),
    );
  }

  Widget productCopy(Product p, BuildContext sheetContext) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p.name, style: _serif.copyWith(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          '${p.rating} · ${p.category}',
          style: const TextStyle(color: _gold, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Text(
          'Cut from considered cloth — a ${p.category.toLowerCase()} piece made to be worn often, and well.',
          style: const TextStyle(color: _muted, height: 1.45),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _cream,
              foregroundColor: _ink,
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () => addToBag(p, sheetContext),
            child: Text('Add to bag · ₹${p.price.toStringAsFixed(0)}'),
          ),
        ),
      ],
    ),
  );

  void showSheet(Product p) => showModalBottomSheet(
    context: context,
    backgroundColor: _panel,
    showDragHandle: true,
    builder: (sheetContext) => productCopy(p, sheetContext),
  );

  void addToBag(Product p, BuildContext sheetContext) {
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
        backgroundColor: _panel,
        content: Text(
          '${p.name} added to your bag.',
          style: const TextStyle(color: _cream),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
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
    final delivery = subtotal == 0 || subtotal >= 150 ? 0.0 : 12.0;
    return Scaffold(
      backgroundColor: _ink,
      appBar: AppBar(
        backgroundColor: _ink,
        foregroundColor: _cream,
        elevation: 0,
        title: Text('Your bag', style: _serif.copyWith(fontSize: 22)),
        centerTitle: false,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 56,
                        color: _muted,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Your bag is waiting',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontFamilyFallback: ['serif', 'Times New Roman'],
                          fontSize: 22,
                          color: _cream,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Add something that sparks joy.',
                        style: TextStyle(color: _muted),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                        itemCount: items.length + 1,
                        itemBuilder: (_, index) {
                          if (index == items.length) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    color: _gold,
                                  ),
                                  SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      'Free delivery on orders over ₹150',
                                      style: TextStyle(color: _muted),
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
                            child: Container(
                              color: _panel,
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ColoredBox(
                                    color: p.color,
                                    child: Image.asset(
                                      p.imageAsset,
                                      width: 64,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              SizedBox(
                                                width: 64,
                                                height: 80,
                                                child: Icon(
                                                  p.icon,
                                                  color: _cream.withValues(
                                                    alpha: 0.35,
                                                  ),
                                                ),
                                              ),
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
                                          style: _serif.copyWith(fontSize: 16),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '₹${p.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: _gold,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () => change(p, -1),
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: _cream,
                                              ),
                                            ),
                                            Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: _cream,
                                              ),
                                            ),
                                            IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () => change(p, 1),
                                              icon: const Icon(
                                                Icons.add_circle,
                                                color: _gold,
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
                                      color: _muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                      color: _panel,
                      child: Column(
                        children: [
                          _row('Subtotal', subtotal),
                          _row('Delivery', delivery),
                          const Divider(height: 24, color: Color(0xff3a3a3a)),
                          _row('Total', subtotal + delivery, bold: true),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: _cream,
                                foregroundColor: _ink,
                                shape: const RoundedRectangleBorder(),
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: _panel,
                                  icon: const Icon(
                                    Icons.check_circle_rounded,
                                    color: _gold,
                                    size: 42,
                                  ),
                                  title: Text(
                                    'Order ready!',
                                    style: _serif.copyWith(fontSize: 22),
                                  ),
                                  content: const Text(
                                    'This is a demo checkout — your picks stay in the bag.',
                                    style: TextStyle(color: _muted),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Continue shopping',
                                        style: TextStyle(color: _cream),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              child: Text(
                                'Checkout · ₹${(subtotal + delivery).toStringAsFixed(0)}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
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
            color: _cream,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            fontSize: bold ? 18 : 14,
          ),
        ),
        const Spacer(),
        Text(
          amount == 0 && label == 'Delivery'
              ? 'Free'
              : '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            fontSize: bold ? 18 : 14,
            color: label == 'Delivery' && amount == 0 ? _gold : _cream,
          ),
        ),
      ],
    ),
  );
}
