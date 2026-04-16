import 'package:flutter/material.dart';

import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/pets/presentation/screens/pets_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/professional/presentation/screens/professional_dashboard_screen.dart';
import '../../features/professional/presentation/screens/professional_workspace_screen.dart';
import '../../shared/models/account_identity_models.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    this.experience = AccountExperience.family,
  });

  final AccountExperience experience;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<_NavigationItem> _items =
      widget.experience == AccountExperience.family
      ? const [
          _NavigationItem(
            screen: HomeScreen(),
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Inicio',
          ),
          _NavigationItem(
            screen: PetsScreen(),
            icon: Icons.pets_outlined,
            selectedIcon: Icons.pets,
            label: 'Mascotas',
          ),
          _NavigationItem(
            screen: ExploreScreen(),
            icon: Icons.explore_outlined,
            selectedIcon: Icons.explore,
            label: 'Explorar',
          ),
          _NavigationItem(
            screen: ProfileScreen(experience: AccountExperience.family),
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Perfil',
          ),
        ]
      : const [
          _NavigationItem(
            screen: ProfessionalDashboardScreen(),
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Inicio',
          ),
          _NavigationItem(
            screen: ProfessionalWorkspaceScreen(),
            icon: Icons.storefront_outlined,
            selectedIcon: Icons.storefront_rounded,
            label: 'Servicios',
          ),
          _NavigationItem(
            screen: ExploreScreen(),
            icon: Icons.explore_outlined,
            selectedIcon: Icons.explore,
            label: 'Explorar',
          ),
          _NavigationItem(
            screen: ProfileScreen(experience: AccountExperience.professional),
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Perfil',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _items.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _items
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.screen,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Widget screen;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
