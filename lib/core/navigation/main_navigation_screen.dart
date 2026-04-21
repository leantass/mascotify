import 'package:flutter/material.dart';

import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/pets/presentation/screens/pets_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/professional/presentation/screens/professional_dashboard_screen.dart';
import '../../features/professional/presentation/screens/professional_workspace_screen.dart';
import '../../shared/models/account_identity_models.dart';
import '../../theme/app_colors.dart';

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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final useRailNavigation = screenWidth >= 960;
    final extendRail = screenWidth >= 1280;

    return Scaffold(
      body: useRailNavigation
          ? SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    extended: extendRail,
                    minExtendedWidth: 220,
                    labelType: extendRail
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,
                    leading: _RailHeader(
                      experience: widget.experience,
                      isExtended: extendRail,
                    ),
                    onDestinationSelected: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    destinations: _items
                        .map(
                          (item) => NavigationRailDestination(
                            icon: Icon(item.icon),
                            selectedIcon: Icon(item.selectedIcon),
                            label: Text(item.label),
                          ),
                        )
                        .toList(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _items.map((item) => item.screen).toList(),
                    ),
                  ),
                ],
              ),
            )
          : IndexedStack(
              index: _currentIndex,
              children: _items.map((item) => item.screen).toList(),
            ),
      bottomNavigationBar: useRailNavigation
          ? null
          : NavigationBar(
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

class _RailHeader extends StatelessWidget {
  const _RailHeader({
    required this.experience,
    required this.isExtended,
  });

  final AccountExperience experience;
  final bool isExtended;

  @override
  Widget build(BuildContext context) {
    final roleLabel = experience == AccountExperience.family
        ? 'Modo familia'
        : 'Modo profesional';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      child: isExtended
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mascotify',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          roleLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.pets_rounded, color: Colors.white),
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
