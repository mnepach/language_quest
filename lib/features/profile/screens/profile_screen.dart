import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/platform_helper.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(PlatformHelper.getResponsivePadding()),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen
                      ? AppDimensions.contentMaxWidth
                      : double.infinity,
                ),
                child: Column(
                  children: [
                    _buildHeader(context),
                    SizedBox(height: AppDimensions.spacingL),
                    _buildProfileCard(context),
                    SizedBox(height: AppDimensions.spacingL),
                    _buildStatsGrid(context),
                    SizedBox(height: AppDimensions.spacingL),
                    _buildAchievementsSection(context),
                    SizedBox(height: AppDimensions.spacingL),
                    _buildSettingsSection(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        Expanded(
          child: Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: AppDimensions.iconXl),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        return Card(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: AppDimensions.avatarXl,
                  height: AppDimensions.avatarXl,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: user?.avatarUrl != null
                      ? ClipOval(
                    child: Image.network(
                      user!.avatarUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(
                    Icons.person,
                    size: AppDimensions.iconXxl,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingM),
                // Username
                Text(
                  user?.username ?? 'User',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingXs),
                // Email
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingL),
                // Level Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.warning],
                    ),
                    borderRadius:
                    BorderRadius.circular(AppDimensions.radiusRound),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.military_tech,
                        color: Colors.white,
                        size: AppDimensions.iconM,
                      ),
                      SizedBox(width: AppDimensions.spacingS),
                      Text(
                        'Level ${user?.level ?? 1}',
                        style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.spacingM),
                // Experience Progress
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Experience',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${user?.experience ?? 0} / ${((user?.level ?? 1) * 100)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacingS),
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(AppDimensions.radiusRound),
                      child: LinearProgressIndicator(
                        value: (user?.experience ?? 0) /
                            ((user?.level ?? 1) * 100),
                        minHeight: AppDimensions.progressBarHeight,
                        backgroundColor: AppColors.bgSecondary,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final progress = user?.progress;

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppDimensions.spacingM,
          crossAxisSpacing: AppDimensions.spacingM,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              context: context,
              icon: Icons.school,
              label: 'Lessons Completed',
              value: '${progress?.completedLessons ?? 0}',
              color: AppColors.success,
            ),
            _buildStatCard(
              context: context,
              icon: Icons.local_fire_department,
              label: 'Current Streak',
              value: '${progress?.currentStreak ?? 0} days',
              color: AppColors.error,
            ),
            _buildStatCard(
              context: context,
              icon: Icons.emoji_events,
              label: 'Longest Streak',
              value: '${progress?.longestStreak ?? 0} days',
              color: AppColors.warning,
            ),
            _buildStatCard(
              context: context,
              icon: Icons.paid,
              label: 'Total Coins',
              value: '${user?.coins ?? 0}',
              color: AppColors.coin,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: AppDimensions.iconL,
            ),
            SizedBox(height: AppDimensions.spacingS),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: AppDimensions.spacingXs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to achievements page
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingM),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              final isUnlocked = index < 2;
              return _buildAchievementBadge(
                context: context,
                icon: Icons.emoji_events,
                title: 'Achievement ${index + 1}',
                isUnlocked: isUnlocked,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isUnlocked,
  }) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: AppDimensions.spacingM),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnlocked
                  ? const LinearGradient(
                colors: [AppColors.accent, AppColors.warning],
              )
                  : LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
              boxShadow: isUnlocked
                  ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ]
                  : null,
            ),
            child: Icon(
              isUnlocked ? icon : Icons.lock,
              color: Colors.white,
              size: AppDimensions.iconL,
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: AppDimensions.spacingM),
        Card(
          child: Column(
            children: [
              _buildSettingsTile(
                context: context,
                icon: Icons.edit,
                title: 'Edit Profile',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                context: context,
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                context: context,
                icon: Icons.language,
                title: 'Language Settings',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                context: context,
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                context: context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  final authProvider = context.read<AuthProvider>();
                  await authProvider.logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                textColor: AppColors.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: AppDimensions.iconS,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
