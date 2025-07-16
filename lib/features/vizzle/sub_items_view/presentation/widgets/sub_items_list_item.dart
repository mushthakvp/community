import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';

class SubItemsListItem extends StatelessWidget {
  final SubItemEntity subItem;
  final VoidCallback onTap;

  const SubItemsListItem({
    super.key,
    required this.subItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            // Item Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppConstants.appPrimaryColor.withOpacity(0.3),
                ),
              ),
              child: Icon(
                _getItemIcon(subItem.name),
                color: AppConstants.appPrimaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),

            // Item Info
            Expanded(
              child: CommonTextWidget(
                text: subItem.name.capitalizeFirstLetter(),
                color: AppConstants.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.white.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getItemIcon(String itemName) {
    final name = itemName.toLowerCase();

    // Electronics
    if (name.contains('mobile') || name.contains('phone')) {
      return Icons.smartphone;
    } else if (name.contains('laptop') || name.contains('computer')) {
      return Icons.laptop;
    } else if (name.contains('tablet')) {
      return Icons.tablet;
    } else if (name.contains('tv') || name.contains('television')) {
      return Icons.tv;
    } else if (name.contains('camera')) {
      return Icons.camera_alt;
    } else if (name.contains('headphone') || name.contains('earphone')) {
      return Icons.headphones;
    } else if (name.contains('speaker')) {
      return Icons.speaker;
    } else if (name.contains('watch')) {
      return Icons.watch;
    }
    // Vehicles
    else if (name.contains('car') ||
        name.contains('sedan') ||
        name.contains('suv')) {
      return Icons.directions_car;
    } else if (name.contains('bike') ||
        name.contains('motorcycle') ||
        name.contains('scooter')) {
      return Icons.two_wheeler;
    } else if (name.contains('truck') || name.contains('lorry')) {
      return Icons.local_shipping;
    } else if (name.contains('bus')) {
      return Icons.directions_bus;
    } else if (name.contains('bicycle') || name.contains('cycle')) {
      return Icons.pedal_bike;
    }
    // Furniture
    else if (name.contains('sofa') || name.contains('chair')) {
      return Icons.chair;
    } else if (name.contains('table') || name.contains('desk')) {
      return Icons.table_restaurant;
    } else if (name.contains('bed')) {
      return Icons.bed;
    } else if (name.contains('wardrobe') || name.contains('closet')) {
      return Icons.checkroom;
    } else if (name.contains('mirror')) {
      return Icons.minor_crash;
    }
    // Fashion
    else if (name.contains('shirt') || name.contains('t-shirt')) {
      return Icons.checkroom;
    } else if (name.contains('pants') || name.contains('jeans')) {
      return Icons.checkroom;
    } else if (name.contains('dress')) {
      return Icons.woman;
    } else if (name.contains('shoes') || name.contains('footwear')) {
      return Icons.sports_soccer; // closest to shoes
    } else if (name.contains('bag') || name.contains('purse')) {
      return Icons.shopping_bag;
    } else if (name.contains('watch')) {
      return Icons.watch;
    } else if (name.contains('jewelry') || name.contains('ring')) {
      return Icons.diamond;
    }
    // Books & Education
    else if (name.contains('book') || name.contains('novel')) {
      return Icons.book;
    } else if (name.contains('magazine') || name.contains('newspaper')) {
      return Icons.article;
    } else if (name.contains('pen') || name.contains('pencil')) {
      return Icons.edit;
    } else if (name.contains('bag') && name.contains('school')) {
      return Icons.school;
    }
    // Sports & Fitness
    else if (name.contains('football') || name.contains('soccer')) {
      return Icons.sports_soccer;
    } else if (name.contains('basketball')) {
      return Icons.sports_basketball;
    } else if (name.contains('cricket')) {
      return Icons.sports_cricket;
    } else if (name.contains('tennis')) {
      return Icons.sports_tennis;
    } else if (name.contains('gym') || name.contains('fitness')) {
      return Icons.fitness_center;
    } else if (name.contains('yoga')) {
      return Icons.self_improvement;
    }
    // Kitchen & Home
    else if (name.contains('kitchen') || name.contains('cooking')) {
      return Icons.kitchen;
    } else if (name.contains('microwave')) {
      return Icons.microwave;
    } else if (name.contains('fridge') || name.contains('refrigerator')) {
      return Icons.kitchen;
    } else if (name.contains('washing')) {
      return Icons.local_laundry_service;
    } else if (name.contains('iron')) {
      return Icons.iron;
    }
    // Toys & Games
    else if (name.contains('toy') || name.contains('game')) {
      return Icons.toys;
    } else if (name.contains('puzzle')) {
      return Icons.extension;
    } else if (name.contains('doll')) {
      return Icons.child_care;
    }
    // Miscellaneous
    else if (name.contains('tool')) {
      return Icons.build;
    } else if (name.contains('plant') || name.contains('garden')) {
      return Icons.local_florist;
    } else if (name.contains('pet') || name.contains('animal')) {
      return Icons.pets;
    } else if (name.contains('music') || name.contains('instrument')) {
      return Icons.music_note;
    } else if (name.contains('art') || name.contains('paint')) {
      return Icons.palette;
    } else if (name.contains('service')) {
      return Icons.room_service;
    } else if (name.contains('other') || name.contains('misc')) {
      return Icons.more_horiz;
    }
    // Default
    else {
      return Icons.category;
    }
  }
}
