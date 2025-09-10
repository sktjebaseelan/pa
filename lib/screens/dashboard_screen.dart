import 'package:expense_tracker/constant/app_pages.dart';
import 'package:expense_tracker/screens/credential/credential_list_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/navigation_cubit.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Academy", "icon": Icons.school, "navigagte": AppPage.academy},
    {
      "title": "Assets",
      "icon": Icons.account_balance,
      "navigagte": AppPage.tracker,
    },
    {
      "title": "System",
      "icon": Icons.settings_system_daydream,
      "navigagte": AppPage.system,
    },
    {"title": "Home", "icon": Icons.track_changes, "navigagte": AppPage.home},
    {
      "title": "Settings",
      "icon": Icons.settings,
      "navigagte": AppPage.settings,
    },
    {
      "title": "Credential",
      "icon": Icons.password,
      "navigagte": AppPage.credential,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, AppPage>(
      builder: (context, state) {
        if (state == AppPage.dashboard) {
          return Scaffold(
            appBar: AppBar(title: Text("Dashboard")),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    onTap: () {
                      context.read<NavigationCubit>().navigateTo(
                        item['navigagte'],
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state == AppPage.home) {
          return HomeScreen(); //✅ show HomeScreen
        } else if (state == AppPage.academy) {
          return Scaffold(body: Center(child: Text("Academy Page")));
        } else if (state == AppPage.assets) {
          return Scaffold(body: Center(child: Text("Assets Page")));
        } else if (state == AppPage.system) {
          return Scaffold(body: Center(child: Text("System Page")));
        } else if (state == AppPage.settings) {
          return Scaffold(body: Center(child: Text("Settings Page")));
        } else if (state == AppPage.credential) {
          return CredentialListScreen();
        } else {
          return Container();
        }
      },
    );
  }
}
