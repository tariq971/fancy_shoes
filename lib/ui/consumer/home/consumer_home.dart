import 'package:fancy_shoes/ui/consumer/home/consumer_home_vm.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/booking_model.dart';
import '../../../models/place_model.dart';

class ConsumerHomePage extends StatefulWidget {
  @override
  State<ConsumerHomePage> createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  late ConsumerHomeViewModel consumerHomeViewModel;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    consumerHomeViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() => Text(
          consumerHomeViewModel.selectedTab.value == 0 ? "Tour Places" : "My Bookings",
        )),
        actions: [
          IconButton(
            onPressed: () async {
              await consumerHomeViewModel.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        return consumerHomeViewModel.selectedTab.value == 0
            ? _buildPlacesTab()
            : _buildMyBookingsTab();
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: consumerHomeViewModel.selectedTab.value,
          onTap: (index) => consumerHomeViewModel.changeTab(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.tour),
              label: "Tour Places",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "My Bookings",
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlacesTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              consumerHomeViewModel.onSearchChanged(value);
            },
            decoration: AppTheme.inputDecoration(
              label: "Search Places",
              hint: "Search by name or description",
              icon: Icons.search,
            ),
          ),
        ),

        // Places Grid
        Expanded(
          child: Obx(() {
            if (consumerHomeViewModel.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (consumerHomeViewModel.filteredPlaces.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 60, color: AppTheme.textLight),
                    const SizedBox(height: 16),
                    const Text("No places found", style: AppTheme.bodyMedium),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: consumerHomeViewModel.filteredPlaces.length,
              itemBuilder: (context, index) {
                Place place = consumerHomeViewModel.filteredPlaces[index];
                return _buildPlaceCard(place);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMyBookingsTab() {
    return Obx(() {
      if (consumerHomeViewModel.myBookings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_border, size: 80, color: AppTheme.textLight),
              const SizedBox(height: 16),
              const Text(
                "No bookings yet",
                style: AppTheme.headingSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                "Book a tour to see your bookings here",
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: consumerHomeViewModel.myBookings.length,
        itemBuilder: (context, index) {
          Booking booking = consumerHomeViewModel.myBookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor;
    IconData statusIcon;

    switch (booking.status) {
      case 'approved':
        statusColor = AppTheme.successColor;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = AppTheme.errorColor;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppTheme.pendingColor;
        statusIcon = Icons.hourglass_empty;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  consumerHomeViewModel.getPlaceName(booking.placeId),
                  style: AppTheme.headingSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 16, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      booking.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quantity and Price Row
          Row(
            children: [
              const Icon(Icons.confirmation_number, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                "Qty: ${booking.quantity}",
                style: AppTheme.labelStyle,
              ),
              const SizedBox(width: 20),
              const Icon(Icons.monetization_on, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                "Rs.${consumerHomeViewModel.getBookingPrice(booking)}",
                style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                booking.phoneNumber.isNotEmpty ? booking.phoneNumber : "N/A",
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.address.isNotEmpty ? booking.address : "N/A",
                  style: AppTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Place place) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/place_details", arguments: place);
      },
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: place.image != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        place.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return Center(
                            child: Icon(Icons.image, size: 50, color: AppTheme.textLight),
                          );
                        },
                      ),
                    )
                  : Center(child: Icon(Icons.tour, size: 50, color: AppTheme.textLight)),
            ),

            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: AppTheme.labelStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Rs.${place.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.event_seat, size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          "${place.availableSlots} slots left",
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

