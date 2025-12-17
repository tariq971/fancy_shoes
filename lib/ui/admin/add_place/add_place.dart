import 'dart:io';
import 'package:fancy_shoes/ui/admin/add_place/add_place_vm.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPlacePage extends StatefulWidget {
  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController slotsController = TextEditingController();
  late AddPlaceViewModel addPlaceViewModel;

  @override
  void initState() {
    super.initState();
    addPlaceViewModel = Get.find();

    // Pre-fill if editing
    if (addPlaceViewModel.existingPlace.value != null) {
      final place = addPlaceViewModel.existingPlace.value!;
      nameController.text = place.name;
      priceController.text = place.price.toString();
      dateFromController.text = place.dateFrom;
      dateToController.text = place.dateTo;
      descriptionController.text = place.description;
      slotsController.text = place.availableSlots.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          addPlaceViewModel.existingPlace.value == null ? "Add New Place" : "Edit Place",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Picker
            Obx(() {
              if (addPlaceViewModel.image.value != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Image.file(
                    File(addPlaceViewModel.image.value!.path),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                );
              } else if (addPlaceViewModel.existingPlace.value?.image != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Image.network(
                    addPlaceViewModel.existingPlace.value!.image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return Icon(Icons.image, size: 100, color: AppTheme.textLight);
                    },
                  ),
                );
              } else {
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(color: AppTheme.borderColor, width: 2),
                  ),
                  child: const Icon(Icons.add_photo_alternate, size: 60, color: AppTheme.textLight),
                );
              }
            }),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                addPlaceViewModel.imagePicker();
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Add Picture"),
              style: AppTheme.secondaryButtonStyle,
            ),
            const SizedBox(height: 24),

            // Name Field
            TextField(
              controller: nameController,
              decoration: AppTheme.inputDecoration(
                label: "Place Name",
                hint: "Enter place name",
                icon: Icons.tour,
              ),
            ),
            const SizedBox(height: 16),

            // Price Field
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: AppTheme.inputDecoration(
                label: "Price",
                hint: "Enter price",
                icon: Icons.monetization_on,
              ),
            ),
            const SizedBox(height: 16),

            // Date From Field
            TextField(
              controller: dateFromController,
              readOnly: true,
              decoration: AppTheme.inputDecoration(
                label: "Start Date",
                hint: "Select start date",
                icon: Icons.calendar_today,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026, 12, 31),
                );
                if (pickedDate != null) {
                  dateFromController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
            ),
            const SizedBox(height: 16),

            // Date To Field
            TextField(
              controller: dateToController,
              readOnly: true,
              decoration: AppTheme.inputDecoration(
                label: "End Date",
                hint: "Select end date",
                icon: Icons.calendar_today,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026, 12, 31),
                );
                if (pickedDate != null) {
                  dateToController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
            ),
            const SizedBox(height: 16),

            // Available Slots Field
            TextField(
              controller: slotsController,
              keyboardType: TextInputType.number,
              decoration: AppTheme.inputDecoration(
                label: "Available Slots",
                hint: "Enter available slots",
                icon: Icons.people,
              ),
            ),
            const SizedBox(height: 16),

            // Description Field
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: AppTheme.inputDecoration(
                label: "Description",
                hint: "Enter description",
                icon: Icons.description,
              ),
            ),

            const SizedBox(height: 24),

            // Save Button
            Obx(() {
              return addPlaceViewModel.isSaving.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          addPlaceViewModel.savePlace(
                            nameController.text,
                            priceController.text,
                            dateFromController.text,
                            dateToController.text,
                            descriptionController.text,
                            slotsController.text,
                          );
                          Get.back(result: true);
                        },
                        style: AppTheme.primaryButtonStyle,
                        child: const Text(
                          "Save Place",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}

