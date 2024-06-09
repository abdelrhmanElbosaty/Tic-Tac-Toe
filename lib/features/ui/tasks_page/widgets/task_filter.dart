import 'package:flutter/material.dart';
import 'package:tic_tak_toe/core/dimensions.dart';
import 'package:tic_tak_toe/core/extensions.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/text_styles.dart';
import '../../../domain/entities/task_entity.dart';

class TaskFilter extends StatefulWidget {
  final Function(TaskFilterEnum filter) onTap;
  final TaskFilterEnum? currentTap;

  const TaskFilter({
    super.key,
    required this.onTap,
    this.currentTap,
  });

  @override
  State<TaskFilter> createState() => _TaskFilterState();
}

class _TaskFilterState extends State<TaskFilter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: PaddingDimensions.large),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                TaskFilterEnum.values.map((e) => _buildWidget(e)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWidget(TaskFilterEnum tap) {
    return GestureDetector(
      onTap: () => widget.onTap(tap),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: PaddingDimensions.large,
              vertical: PaddingDimensions.normal),
          child: Column(
            children: [
              Text(
                tap.name,
                style: TextStyles.medium(
                  fontSize: Dimensions.xxLarge,
                  color: widget.currentTap == tap
                      ? AppColors.secondaryColor
                      : Colors.black,
                ),
              ),
              Container(
                height: 1.5,
                width: tap.name.getWidth + 2,
                color:
                    widget.currentTap == tap ? AppColors.secondaryColor : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
