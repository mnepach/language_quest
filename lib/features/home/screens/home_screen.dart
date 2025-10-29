import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = kIsWeb && size.width > AppDimensions.tabletMaxWidth;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgPrimary,
              AppColors.bgSecondary.withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: isWideScreen ? _buildWebLayout() : _buildMobileLayout(),
        ),
      ),
      bottomNavigationBar:
      isWideScreen ? null : _buildBottomNavigationBar(),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          backgroundColor: Colors.white.withOpacity(0.9),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book),
              label: Text('Lessons'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.games_outlined),
              selectedIcon: Icon(Icons.games),
              label: Text('Games'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: Text('Profile'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return _buildContent();
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppDimensions.spacingXl),
          _buildStatsCards(),
          SizedBox(height: AppDimensions.spacingXl),
          _buildLevelsSection(),
          SizedBox(height: AppDimensions.spacingXl),
          _buildContinueLearning(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    user?.username ?? 'Adventurer',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.error),
              onPressed: () async {
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCards() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.star,
                color: AppColors.star,
                label: 'Level',
                value: '${user?.level ?? 1}',
              ),
            ),
            SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: _buildStatCard(
                icon: Icons.local_fire_department,
                color: AppColors.error,
                label: 'Streak',
                value: '${user?.progress?.currentStreak ?? 0}',
              ),
            ),
            SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: _buildStatCard(
                icon: Icons.paid,
                color: AppColors.coin,
                label: 'Coins',
                value: '${user?.coins ?? 0}',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppDimensions.iconXl),
            SizedBox(height: AppDimensions.spacingS),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Journey',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: AppDimensions.spacingM),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildLevelCard(index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(int level) {
    final isLocked = level > 2;

    return Container(
      width: 160,
      margin: EdgeInsets.only(right: AppDimensions.spacingM),
      child: Card(
        child: InkWell(
          onTap: isLocked ? null : () {},
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isLocked
                          ? [Colors.grey, Colors.grey.shade300]
                          : [AppColors.primary, AppColors.secondary],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isLocked ? Icons.lock : Icons.book,
                      size: AppDimensions.iconXl,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.spacingM),
                Text(
                  'Level $level',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isLocked ? 'Locked' : 'In Progress',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Learning',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: AppDimensions.spacingM),
        Card(
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white),
            ),
            title: const Text('Basic Vocabulary'),
            subtitle: const Text('Lesson 3 - Food & Drinks'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          activeIcon: Icon(Icons.book),
          label: 'Lessons',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.games_outlined),
          activeIcon: Icon(Icons.games),
          label: 'Games',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
