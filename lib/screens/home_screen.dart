import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:recyclo_admin_panel/screens/sidebar_screens/buyers_screen.dart';
import 'package:recyclo_admin_panel/screens/sidebar_screens/dashboard_screen.dart';
import 'package:recyclo_admin_panel/screens/sidebar_screens/feedback_screen.dart';
import 'package:recyclo_admin_panel/screens/sidebar_screens/sellers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedItem = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });

        break;

      case SellerScreen.routeName:
        setState(() {
          _selectedItem = SellerScreen();
        });

        break;

      case BuyerScreen.routeName:
        setState(() {
          _selectedItem = BuyerScreen();
        });

        break;

      case FeedbackScreen.routeName:
        setState(() {
          _selectedItem = FeedbackScreen();
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Color.fromARGB(234, 244, 244, 244),
      appBar: AppBar(
        title: Text(
          "Administration",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 110, 110, 214),
      ),
      sideBar: SideBar(
        iconColor: Color.fromARGB(255, 110, 110, 214),
        backgroundColor: Color.fromARGB(66, 152, 150, 150),
        items: [
          const AdminMenuItem(
              title: 'Dashboard',
              icon: Icons.dashboard,
              route: DashboardScreen.routeName),
          AdminMenuItem(
              title: 'Sellers',
              icon: Icons.sell,
              route: SellerScreen.routeName),
          AdminMenuItem(
              title: 'Buyers', icon: Icons.shop, route: BuyerScreen.routeName),
          AdminMenuItem(
              title: 'Feedback',
              icon: Icons.feedback_rounded,
              route: FeedbackScreen.routeName),
        ],
        selectedRoute: "",
        onSelected: (item) {
          screenSelector(item);
        },
      ),
      body: _selectedItem,
    );
  }
}
