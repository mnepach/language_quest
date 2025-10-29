import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

class GameCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isLocked;
  final int? requiredLevel;
  final String? imageUrl;

  const GameCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color = AppColors.primary,
    this.onTap,
    this.isLocked = false,
    this.requiredLevel,
    this.imageUrl,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLocked && widget.onTap != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    if (!widget.isLocked && widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.95 : 1.0),
        child: Container(
          width: AppDimensions.cardWidth,
          height: AppDimensions.cardHeight,
          decoration: BoxDecoration(
            gradient: widget.isLocked
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade400,
              ],
            )
                : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color,
                widget.color.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: widget.isLocked
                  ? Colors.grey.shade500
                  : Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isLocked
                    ? Colors.grey.withOpacity(0.3)
                    : widget.color.withOpacity(0.4),
                blurRadius: _isPressed ? 8 : 16,
                offset: Offset(0, _isPressed ? 2 : 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PatternPainter(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(AppDimensions.spacingS),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Icon(
                          widget.isLocked ? Icons.lock : widget.icon,
                          color: Colors.white,
                          size: AppDimensions.iconXl,
                        ),
                      ),
                      const Spacer(),
                      // Title
                      Text(
                        widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimensions.spacingXs),
                      // Description
                      Text(
                        widget.isLocked && widget.requiredLevel != null
                            ? 'Unlock at Level ${widget.requiredLevel}'
                            : widget.description,
                        style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Locked overlay
                if (widget.isLocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius:
                        BorderRadius.circular(AppDimensions.radiusL),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw simple geometric pattern
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 5; j++) {
        final x = (size.width / 5) * i + (size.width / 10);
        final y = (size.height / 5) * j + (size.height / 10);

        canvas.drawCircle(
          Offset(x, y),
          3,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Широкая карточка игры для горизонтального отображения
class WideGameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isLocked;
  final int? stars;
  final String? bestScore;

  const WideGameCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color = AppColors.primary,
    this.onTap,
    this.isLocked = false,
    this.stars,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          child: Row(
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: isLocked
                      ? LinearGradient(
                    colors: [Colors.grey, Colors.grey.shade400],
                  )
                      : LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  isLocked ? Icons.lock : icon,
                  color: Colors.white,
                  size: AppDimensions.iconL,
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (stars != null || bestScore != null) ...[
                      SizedBox(height: AppDimensions.spacingS),
                      Row(
                        children: [
                          if (stars != null) ...[
                            Icon(Icons.star,
                                size: 16, color: AppColors.star),
                            SizedBox(width: AppDimensions.spacingXs),
                            Text('$stars',
                                style: Theme.of(context).textTheme.bodySmall),
                            SizedBox(width: AppDimensions.spacingM),
                          ],
                          if (bestScore != null) ...[
                            Icon(Icons.emoji_events,
                                size: 16, color: AppColors.coin),
                            SizedBox(width: AppDimensions.spacingXs),
                            Text(bestScore!,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow
              Icon(
                isLocked
                    ? Icons.lock_outline
                    : Icons.arrow_forward_ios,
                color: isLocked
                    ? AppColors.textSecondary
                    : AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
