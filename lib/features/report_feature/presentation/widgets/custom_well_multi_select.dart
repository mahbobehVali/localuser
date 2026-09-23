import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../config/color_palette.dart';
import '../../../status_summary_feature/domain/entity/wells_entity.dart';

class CustomWellMultiSelectField extends StatefulWidget {
  final List<WellsEntity> allWells;
  final List<int> selectedWellIds;
  // 🟢 تغییر callback برای ارسال همزمان IDها و Nameها
  final Function(List<int> selectedIds, List<String> selectedNames) onConfirm;

  const CustomWellMultiSelectField({
    Key? key,
    required this.allWells,
    required this.selectedWellIds,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<CustomWellMultiSelectField> createState() => _CustomWellMultiSelectFieldState();
}

class _CustomWellMultiSelectFieldState extends State<CustomWellMultiSelectField> {

  // 🟢 متد کمکی برای دریافت عنوان نمایش داده شده در کادر اصلی
  String _getDisplayText() {
    if (widget.selectedWellIds.isEmpty) {
      return "انتخاب چاه";
    } else if (widget.selectedWellIds.length == 1) {
      // پیدا کردن نام چاه بر اساس ID انتخاب شده
      final selectedWell = widget.allWells.firstWhere(
            (well) => well.data?.deviceId == widget.selectedWellIds.first,
        orElse: () => WellsEntity(),
      );
      return selectedWell.data?.wellName?.toString().toPersianDigit() ?? "انتخاب چاه";
    } else {
      return "${widget.selectedWellIds.length.toString().toPersianDigit()} چاه";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCustomDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _getDisplayText(), // 🟢 استفاده از متن جدید
                style: TextStyle(color: ColorPalette.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: ColorPalette.black),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    List<int> tempSelectedIds = List.from(widget.selectedWellIds);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            bool isAllSelected = tempSelectedIds.length == widget.allWells.length;

            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: const EdgeInsets.all(16),
              title: const Text("انتخاب چاه", textAlign: TextAlign.right),
              content: SizedBox(
                width: double.maxFinite,
                height: ((widget.allWells.length + 1) * 50.0).clamp(150.0, 400.0),
                child: Column(
                  children: [
                    _buildCustomCheckboxTile(
                      title: "انتخاب همه",
                      value: isAllSelected,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            tempSelectedIds = widget.allWells
                                .map((e) => e.data!.deviceId!)
                                .toList();
                          } else {
                            tempSelectedIds.clear();
                          }
                        });
                      },
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.allWells.length,
                        itemBuilder: (context, index) {
                          final well = widget.allWells[index];
                          final isSelected = tempSelectedIds.contains(well.data!.deviceId);

                          return _buildCustomCheckboxTile(
                            title: well.data!.wellName.toString().toPersianDigit(),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setStateDialog(() {
                                if (value == true) {
                                  tempSelectedIds.add(well.data!.deviceId!);
                                } else {
                                  tempSelectedIds.remove(well.data!.deviceId);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("بستن", style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    // 🟢 استخراج نام چاه‌های انتخاب شده
                    List<String> selectedNames = widget.allWells
                        .where((well) => tempSelectedIds.contains(well.data?.deviceId))
                        .map((well) => well.data?.wellName ?? '')
                        .toList();

                    // ارسال هم IDها و هم Nameها
                    widget.onConfirm(tempSelectedIds, selectedNames);
                    Navigator.pop(context);
                  },
                  child: const Text("تایید", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCustomCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: Checkbox(
                value: value,
                activeColor: ColorPalette.darkBlue,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}