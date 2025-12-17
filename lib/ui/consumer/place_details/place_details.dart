import 'package:fancy_shoes/ui/consumer/place_details/place_details_vm.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceDetailsPage extends StatefulWidget {
  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  late PlaceDetailsViewModel placeDetailsViewModel;
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    placeDetailsViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Place Details"),
      ),
      body: Obx(() {
        final place = placeDetailsViewModel.place.value;
        if (place == null) {
          return const Center(child: Text("Place not found", style: AppTheme.bodyMedium));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                height: 250,
                width: double.infinity,
                color: AppTheme.backgroundColor,
                child: place.image != null
                    ? Image.network(
                        place.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return Center(
                            child: Icon(Icons.image, size: 100, color: AppTheme.textLight),
                          );
                        },
                      )
                    : Center(child: Icon(Icons.tour, size: 100, color: AppTheme.textLight)),
              ),

              // Details
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, style: AppTheme.headingLarge),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: AppTheme.primaryColor, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          "Rs.${place.price}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppTheme.textSecondary, size: 18),
                        const SizedBox(width: 8),
                        Text("From: ${place.dateFrom}", style: AppTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppTheme.textSecondary, size: 18),
                        const SizedBox(width: 8),
                        Text("To: ${place.dateTo}", style: AppTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.people, color: AppTheme.textSecondary, size: 18),
                        const SizedBox(width: 8),
                        Text("Available Slots: ${place.availableSlots}", style: AppTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Divider(color: AppTheme.dividerColor, thickness: 1),
                    const SizedBox(height: 16),

                    // Quantity Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Select Quantity:", style: AppTheme.labelStyle),
                        Row(
                          children: [
                            // Minus Button
                            Obx(() => IconButton(
                                  onPressed: placeDetailsViewModel.canDecrement
                                      ? placeDetailsViewModel.decrementQuantity
                                      : () => placeDetailsViewModel.decrementQuantity(),
                                  icon: const Icon(Icons.remove_circle_outline),
                                  iconSize: 28,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  color: placeDetailsViewModel.canDecrement
                                      ? AppTheme.primaryColor
                                      : AppTheme.textLight,
                                )),
                            const SizedBox(width: 12),
                            // Quantity Display
                            Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.borderColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${placeDetailsViewModel.quantity.value}",
                                    style: AppTheme.labelStyle,
                                  ),
                                )),
                            const SizedBox(width: 12),
                            // Plus Button
                            Obx(() => IconButton(
                                  onPressed: placeDetailsViewModel.canIncrement
                                      ? placeDetailsViewModel.incrementQuantity
                                      : () => placeDetailsViewModel.incrementQuantity(),
                                  icon: const Icon(Icons.add_circle_outline),
                                  iconSize: 28,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  color: placeDetailsViewModel.canIncrement
                                      ? AppTheme.primaryColor
                                      : AppTheme.textLight,
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Total Price Display
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Total: ", style: AppTheme.bodyMedium),
                            Text(
                              "Rs.${placeDetailsViewModel.totalPrice.value}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 16),

                    const Divider(color: AppTheme.dividerColor, thickness: 1),
                    const SizedBox(height: 16),

                    const Text("Description:", style: AppTheme.labelStyle),
                    const SizedBox(height: 8),
                    Text(place.description, style: AppTheme.bodyMedium),

                    const SizedBox(height: 24),

                    // Phone Number Input
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: AppTheme.inputDecoration(
                        label: "Phone Number",
                        hint: "Enter your phone number",
                        icon: Icons.phone,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Address Input
                    TextField(
                      controller: addressController,
                      maxLines: 3,
                      decoration: AppTheme.inputDecoration(
                        label: "Address",
                        hint: "Enter your complete address",
                        icon: Icons.location_on,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Book Button
                    Obx(() {
                      return placeDetailsViewModel.isBooking.value
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: place.availableSlots > 0
                                    ? () {
                                        placeDetailsViewModel.bookPlace(
                                          phoneController.text,
                                          addressController.text,
                                        );
                                      }
                                    : null,
                                style: AppTheme.primaryButtonStyle,
                                child: Text(
                                  place.availableSlots > 0 ? "Book Now" : "No Slots Available",
                                  style: const TextStyle(
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
            ],
          ),
        );
      }),
    );
  }
}

