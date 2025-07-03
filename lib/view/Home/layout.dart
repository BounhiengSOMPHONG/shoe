import 'package:app_shoe/controller/cart_c.dart';
import 'package:app_shoe/controller/favorite_c.dart';
import 'package:app_shoe/controller/shop_c.dart';
import 'package:app_shoe/view/Home/account.dart';
import 'package:app_shoe/view/Home/cart.dart';
import 'package:app_shoe/view/Home/favorite.dart';
import 'package:app_shoe/view/Home/home.dart';
import 'package:app_shoe/view/Home/shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final shop_c = Get.put(ShopC());
  final fav_c = Get.put(FavoriteC());
  final cart_c = Get.put(CartC()); // Add CartC controller
  int _currentPage = 0;
  final List<Widget> _pages = [
    Home(),
    Shop(),
    Cart(),
    Favorite(),
    Account(),
  ]; // Add your other pages here
  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          _currentPage == 4
              ? null
              : AppBar(
                toolbarHeight: s.height * 0.08,
                backgroundColor: Colors.transparent,
                elevation: 0,
                // leading: SizedBox.shrink(),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.apps)),
                ),
                title: InkWell(
                  child: Center(
                    child: Image.asset('images/LOGO.png', width: s.width * 0.3),
                  ),
                  onTap: () {
                    setState(() {
                      _currentPage = 0;
                    });
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: Icon(Icons.notifications, color: Colors.yellow),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                Obx(
                  () =>
                      cart_c.items.length >
                              0 // Add conditional check here
                          ? Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${cart_c.items.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          : SizedBox.shrink(), // Hide the badge if count is 0
                ),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _currentPage,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
          if (_currentPage == 1) {
            shop_c.selectedCategory.value = '';
            shop_c.refreshShopData();
          }
          if (_currentPage == 3) {
            fav_c.initUserId();
          }
        },
      ),
    );
  }
}
