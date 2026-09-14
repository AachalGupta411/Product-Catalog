# Luma Apparel Editorial Catalog

Date: 2026-09-14  
Status: Approved for implementation planning  
App: Flutter product catalog (`product_catalog`)

## Goal

Restyle Luma into a dark editorial apparel shop while meeting the assignment:

- Dynamic product listing with `ListView.builder`
- `Product` data model class
- Search and filter using `setState`

The listing is a two-column gallery implemented **inside** `ListView.builder` (two tiles per row). Do not use `GridView.builder` for the graded product list.

## Assignment constraints (must keep)

| Requirement | How it is met |
| --- | --- |
| Data model class | Keep `Product` with name, category, price, rating, color, icon, tag, imageAsset |
| `ListView.builder` | Catalog body is a `ListView.builder` over filtered products, two items per row |
| Search / filter with `setState` | Search field and category tabs call `setState`; a getter returns the filtered list |

Bag, favorites, and demo checkout stay as extras. They do not replace the listing, search, or filter.

## Visual system

- Background: `#111111` (screens), slightly lighter sheet/cards `#1A1A1A`
- Text and rules: cream `#F4EFE6`
- Accent for price / selected tab: cream or muted gold `#C4A574`
- Headlines: serif (`Georgia` via `fontFamily` is enough; no extra font package required)
- Body / search: system sans
- No purple seed theme, no pastel product chips, no rounded candy cards
- Search: dark field, 1px cream-muted border, no filled Material purple
- Categories: text tabs `ALL · OUTER · TOPS · TROUSERS · ACCESSORIES`, selected = cream underline

## Screens

### Catalog (home)

- Header: `LUMA` letter-spacing + serif line “Quiet cloth.” + bag icon with count
- Search field (hint: coats, shirts, trousers)
- Category tabs (horizontal)
- Optional saved / top-rated control kept, restyled to cream/gold
- `ListView.builder` rows: each item is a `Row` of one or two product tiles
- Empty filter result: centered “Nothing in the rack” plus hint to change search or category

### Product tile

- Tall image block
- Name (serif), category, price
- Favorite mark (cream outline; filled `#C4A574` when saved)
- Tap opens dark bottom sheet

### Product bottom sheet

- Stay on the grid
- Drag handle, name, short apparel copy, rating, cream full-width **Add to bag · ₹…**
- Adding updates `cartItems` via `setState` and shows a dark floating snackbar

### Bag

- Same black/cream treatment
- Quantity steppers, remove, subtotal / delivery / total
- Free delivery over ₹150 unchanged
- Demo checkout dialog restyled, same behavior

## Product catalog (replace tech set)

Six in-memory apparel products. Categories must match the tabs (except `All`).

| Name | Category | Price (₹) | Rating | Tag |
| --- | --- | --- | --- | --- |
| Wool Coat | Outer | 8900 | 4.8 | Bestseller |
| Silk Shirt | Tops | 3200 | 4.6 | New drop |
| Wide Trousers | Trousers | 4100 | 4.7 | Popular |
| Leather Belt | Accessories | 1650 | 4.5 | Limited |
| Cashmere Knit | Tops | 5400 | 4.9 | Editor's pick |
| Linen Overshirt | Outer | 3800 | 4.4 | Planet kind |

Hero banner (“Weekend Edit” / audio CTA) is removed. The listing is the hero.

### Images

Add six dark still-life apparel PNGs under `assets/images/` named to match `imageAsset` (e.g. `wool-coat.png`, `silk-shirt.png`). Create them during implementation. Do not reference the old tech image files from code. `pubspec.yaml` already includes `assets/images/`.

## Data flow

Catalog `State` holds:

- `search` controller + `query` string
- `category` (`All` or a clothing category)
- `favoritesOnly` + `favorites` set of product names
- `cartItems` map of name → quantity
- `products` const list of `Product`

`filtered` getter:

1. Category is `All` **or** `product.category == category`
2. `'${name} ${category} ${tag}'` contains `query` (case-insensitive)
3. If `favoritesOnly`, name is in `favorites`
4. Sort by rating descending (keep current behavior)

`ListView.builder`:

- `itemCount = (filtered.length / 2).ceil()` when not empty
- Index `i` shows `filtered[i * 2]` and optionally `filtered[i * 2 + 1]`
- Odd last row: one tile, empty space on the right (not a dummy product)

Every search change, category tap, favorite toggle, and add-to-bag calls `setState`.

No network. No loading spinner. No error screen.

Empty bag: keep “Your bag is waiting” copy, restyled.

## File structure

Stay in `lib/main.dart` plus `test/widget_test.dart` and new image assets. Do not split into a multi-file architecture for this assignment — graders typically open `main.dart`.

Theme: `ThemeData` dark, cream `ColorScheme`, `useMaterial3: true`.

## Testing

Replace the default counter test in `test/widget_test.dart`:

1. Pump `MyApp`, find at least one apparel name (e.g. Wool Coat)
2. Enter a search that matches one product; other names are gone
3. Clear search, tap a category (e.g. Trousers); only that category remains
4. Search with no matches; empty-state copy is visible

Use `flutter test`. Widget tests should not depend on network.

## Out of scope

- `GridView.builder` as the product list
- Size / color pickers, login, real payments
- New packages (no `google_fonts` required)
- Changing Android/iOS native chrome beyond what Flutter theme covers

## Success

A TA can open `lib/main.dart` and point to: `class Product`, `ListView.builder`, and `setState` on search and filter. The UI reads as a dark apparel lookbook, not a purple tech shop.
