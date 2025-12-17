import 'package:fancy_shoes/ui/admin/dashboard/admin_dashboard_vm.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/booking_model.dart';
import '../../../models/place_model.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late AdminDashboardViewModel adminDashboardViewModel;


  @override
  void initState() {
    super.initState();
    adminDashboardViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () async {
              await adminDashboardViewModel.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        return adminDashboardViewModel.selectedTab.value == 0
            ? _buildPlacesTab()
            : _buildBookingsTab();
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: adminDashboardViewModel.selectedTab.value,
          onTap: (index) => adminDashboardViewModel.changeTab(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: "Manage Places",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "Manage Bookings",
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        return adminDashboardViewModel.selectedTab.value == 0
            ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed("/add_place");
                },
                child: const Icon(Icons.add),
              )
            : const SizedBox();
      }),
    );
  }

  Widget _buildPlacesTab() {
    return Obx(() {
      if (adminDashboardViewModel.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (adminDashboardViewModel.places.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_location_alt, size: 60, color: AppTheme.textLight),
              const SizedBox(height: 16),
              const Text("No places added yet", style: AppTheme.bodyMedium),
              const SizedBox(height: 8),
              const Text("Tap + to add a new place", style: AppTheme.bodySmall),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: adminDashboardViewModel.places.length,
        itemBuilder: (context, index) {
          Place place = adminDashboardViewModel.places[index];
          return _buildPlaceItem(place);
        },
      );
    });
  }

  Widget _buildPlaceItem(Place place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          // Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: place.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      place.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return Center(child: Icon(Icons.image, color: AppTheme.textLight));
                      },
                    ),
                  )
                : Center(child: Icon(Icons.tour, color: AppTheme.textLight)),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.name, style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                Text(
                  "Rs.${place.price} • ${place.availableSlots} slots",
                  style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "${place.dateFrom} - ${place.dateTo}",
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Get.toNamed("/add_place", arguments: place);
                },
                icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
              ),
              IconButton(
                onPressed: () {
                  _showDeleteDialog(place);
                },
                icon: const Icon(Icons.delete, color: AppTheme.errorColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return Obx(() {
      if (adminDashboardViewModel.bookings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_border, size: 60, color: AppTheme.textLight),
              const SizedBox(height: 16),
              const Text("No bookings yet", style: AppTheme.bodyMedium),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: adminDashboardViewModel.bookings.length,
        itemBuilder: (context, index) {
          Booking booking = adminDashboardViewModel.bookings[index];
          return _buildBookingItem(booking);
        },
      );
    });
  }

  Widget _buildBookingItem(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                adminDashboardViewModel.getUserDisplayName(booking.id, booking.userId),
                style: AppTheme.labelStyle,
              ),
              AppTheme.statusBadge(booking.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Tour: ${adminDashboardViewModel.getPlaceName(booking.placeId)}",
            style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "Qty: ${booking.quantity}",
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(width: 16),
              Text(
                "Total: Rs.${adminDashboardViewModel.getBookingPrice(booking)}",
                style: const TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Phone: ${booking.phoneNumber}",
            style: AppTheme.bodySmall,
          ),
          Text(
            "Address: ${booking.address}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  adminDashboardViewModel.updateBookingStatus(booking.id, "rejected");
                },
                child: const Text(
                  "Reject",
                  style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  adminDashboardViewModel.updateBookingStatus(booking.id, "approved");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Approve",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  void _showDeleteDialog(Place place) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
        title: const Text("Delete Place", style: AppTheme.headingSmall),
        content: Text("Are you sure you want to delete ${place.name}?", style: AppTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              adminDashboardViewModel.deletePlace(place);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

