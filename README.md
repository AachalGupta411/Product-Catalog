# Luma — Product Catalog

A modern product catalog application built with **Flutter and Dart**.

This project demonstrates how to create a dynamic product listing using `ListView.builder`, organize product information with a data model, and implement search and filtering using `setState()`.

---

## 📱 Overview

**Luma** is a simple fashion-focused product catalog that allows users to browse products, search through the catalog, filter products by category, and view saved products.

The application uses a clean dark-themed interface with product cards containing images, names, categories, prices, and favorite controls.

---

## ✨ Features

- 🛍️ Dynamic product listing
- 🔎 Product search
- 🗂️ Category filtering
- ❤️ Save/favorite products
- 📋 Saved products filter
- 🖼️ Product images
- 💰 Product pricing
- 🔄 Dynamic UI updates using `setState()`
- 📱 Clean and modern Flutter UI

---

##
<img width="1470" height="956" alt="Screenshot 2026-09-14 at 10 24 46 PM" src="https://github.com/user-attachments/assets/fd5b8f49-618f-4dd0-9f98-5ec35514b833" />
<img width="1470" height="956" alt="Screenshot 2026-09-14 at 10 24 57 PM" src="https://github.com/user-attachments/assets/9430b3ca-662a-4648-8d5f-2d9cb1addb02" />



## 🗂️ Categories

Users can filter products using:

- **All**
- **Outer**
- **Tops**
- **Trousers**
- **Accessories**
- **Saved**

---

## 🛒 Product Catalog

| Product | Category | Price |
|---|---|---:|
| Cashmere Knit | Tops | ₹5400 |
| Wool Coat | Outer | ₹8900 |
| Wide Trousers | Trousers | ₹4100 |
| Silk Shirt | Tops | ₹3200 |
| Linen Overshirt | Outer | ₹3800 |
| Leather Belt | Accessories | ₹1650 |

---

## 🧠 Core Concepts

### Data Model

Product information is represented using a dedicated data model instead of keeping individual product values separately.

This makes the product data structured and easier to manage.

### `ListView.builder`

`ListView.builder` is used to dynamically generate the product cards from the product collection.

This avoids manually creating a separate widget for every product.

### `setState()`

`setState()` is used whenever the application state changes.

It allows the interface to update when the user:

- Searches for a product
- Changes the selected category
- Saves or unsaves a product
- Changes the displayed product collection

### Search & Filtering

The filtering flow is:

```text
User Interaction
       ↓
Search / Category / Saved
       ↓
Update State
       ↓
setState()
       ↓
Filter Products
       ↓
ListView.builder
       ↓
Updated Product List
