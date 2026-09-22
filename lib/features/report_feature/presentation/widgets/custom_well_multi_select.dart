import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../config/color_palette.dart';
import '../../../status_summary_feature/domain/entity/wells_entity.dart';


class CustomWellMultiSelectField extends StatefulWidget {
  final List<WellsEntity> allWells;
  final List<int> selectedWellIds;
  final Function(List<int>) onConfirm;

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
  @override
  Widget build(context) {
    return InkWell(
      onTap: () => _showCustomDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedWellIds.isEmpty
                  ? "انتخاب چاه"
                  : "تعداد: ${widget.selectedWellIds.length.toString().toPersianDigit()} چاه",
              style:  TextStyle(color: ColorPalette.black),
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
            print("widget.allWells.length${widget.allWells.length}");
            bool isAllSelected = tempSelectedIds.length == widget.allWells.length;

            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: const EdgeInsets.all(16),
              // ✅ حذف عنوان پیش‌فرض برای مدیریت بهتر فضا
              title: const Text("انتخاب چاه", textAlign: TextAlign.right,),
              content: SizedBox(
                width: double.maxFinite,
                // محاسبه ارتفاع: هدر (۵۰) + هر آیتم (۵۰)
                height: ((widget.allWells.length + 1) * 50.0).clamp(150.0, 400.0),
                child: Column(
                  children: [
                    // ✅ گزینه «انتخاب همه» با چیدمان سفارشی
                    _buildCustomCheckboxTile(
                      title: "انتخاب همه",
                      value: isAllSelected,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            tempSelectedIds = widget.allWells.map((e) => e.data!.deviceId!).toList();
                          } else {
                            tempSelectedIds.clear();
                          }
                        });
                      },
                    ),
                    const Divider(height: 1),
                    // لیست مناطق
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.allWells.length,
                        itemBuilder: (context, index) {

                          final well = widget.allWells[index];
                          final isSelected = tempSelectedIds.contains(well.data!.deviceId);

                          // ✅ هر آیتم منطقه با چیدمان سفارشی
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
                    widget.onConfirm(tempSelectedIds);
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

  // ✅ متد کمکی برای ساخت ردیف سفارشی (چک‌باکس و عنوان کنار هم)
  Widget _buildCustomCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      // با کلیک روی کل ردیف، چک‌باکس تغییر وضعیت می‌دهد
      onTap: () => onChanged(!value),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //  چک‌باکس
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: Checkbox(
                value: value,
                activeColor: ColorPalette.darkBlue,
                onChanged: onChanged, // مدیریت تغییر وضعیت از طریق خود چک‌باکس
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // برای حذف فضای اضافی لمس در صورت نیاز
              ),
            ),
            //  عنوان
            const SizedBox(width: 16.0), // فاصله بین عنوان و چک‌باکس

            Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),

          ],
        ),
      ),
    );
  }}