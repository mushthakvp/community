import 'package:flutter/material.dart';

class ChatShimmerWidget extends StatefulWidget {
  const ChatShimmerWidget({super.key});

  @override
  State<ChatShimmerWidget> createState() => _ChatShimmerWidgetState();
}

class _ChatShimmerWidgetState extends State<ChatShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment(_animation.value, 0),
                  end: const Alignment(1, 0),
                  colors: [
                    Theme.of(context).colorScheme.surfaceVariant,
                    Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(0.5),
                    Theme.of(context).colorScheme.surfaceVariant,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MessageShimmerWidget extends StatefulWidget {
  const MessageShimmerWidget({super.key});

  @override
  State<MessageShimmerWidget> createState() => _MessageShimmerWidgetState();
}

class _MessageShimmerWidgetState extends State<MessageShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        final isCurrentUser = index % 2 == 0;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isCurrentUser) ...[
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment(_animation.value, 0),
                          end: const Alignment(1, 0),
                          colors: [
                            Theme.of(context).colorScheme.surfaceVariant,
                            Theme.of(
                              context,
                            ).colorScheme.surfaceVariant.withOpacity(0.5),
                            Theme.of(context).colorScheme.surfaceVariant,
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment(_animation.value, 0),
                        end: const Alignment(1, 0),
                        colors: [
                          Theme.of(context).colorScheme.surfaceVariant,
                          Theme.of(
                            context,
                          ).colorScheme.surfaceVariant.withOpacity(0.5),
                          Theme.of(context).colorScheme.surfaceVariant,
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (isCurrentUser) ...[
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment(_animation.value, 0),
                          end: const Alignment(1, 0),
                          colors: [
                            Theme.of(context).colorScheme.surfaceVariant,
                            Theme.of(
                              context,
                            ).colorScheme.surfaceVariant.withOpacity(0.5),
                            Theme.of(context).colorScheme.surfaceVariant,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
