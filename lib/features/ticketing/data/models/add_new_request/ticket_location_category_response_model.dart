import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';

class TicketLocationCategoryResponseModel {
  int? status;
  String? message;
  TicketLocationCategoryModel? ticketLocationCategory;

  TicketLocationCategoryResponseModel({
    this.status,
    this.message,
    this.ticketLocationCategory,
  });

  factory TicketLocationCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketLocationCategoryResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      ticketLocationCategory: TicketLocationCategoryModel.fromJson(json),
    );
  }
}

class TicketLocationCategoryModel extends TicketLocationCategoryEntity {
  const TicketLocationCategoryModel({
    super.locationDetails,
    super.categoryDetails,
  });

  factory TicketLocationCategoryModel.fromJson(Map<String, dynamic> json) {
    return TicketLocationCategoryModel(
      locationDetails: json['LocationDetails'] != null
          ? (json['LocationDetails'] as List)
              .map((i) => LocationDetailsModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      categoryDetails: json['CategoryDetails'] != null
          ? (json['CategoryDetails'] as List)
              .map((i) => CategoryModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  TicketLocationCategoryEntity toEntity() {
    return TicketLocationCategoryEntity(
      locationDetails: locationDetails,
      categoryDetails: categoryDetails,
    );
  }
}

class LocationDetailsModel extends LocationDetailsEntity {
  const LocationDetailsModel({
    super.lastLocation,
    super.favouriteLocation,
    super.allLocation,
  });

  factory LocationDetailsModel.fromJson(Map<String, dynamic> json) {
    return LocationDetailsModel(
      lastLocation: json['Last_Location'] != null
          ? (json['Last_Location'] as List)
              .map((i) => LocationModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      favouriteLocation: json['Favourite_Location'] != null
          ? (json['Favourite_Location'] as List)
              .map((i) => LocationModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      allLocation: json['All_Location'] != null
          ? (json['All_Location'] as List)
              .map((i) => LocationModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  LocationDetailsEntity toEntity() {
    return LocationDetailsEntity(
      lastLocation: lastLocation,
      favouriteLocation: favouriteLocation,
      allLocation: allLocation,
    );
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({
    super.locationId,
    super.locationDesc,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      locationId: json['LocationID'] as int?,
      locationDesc: json['Location_Desc'] as String?,
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(
      locationId: locationId,
      locationDesc: locationDesc,
    );
  }
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    super.categoryId,
    super.categoryDesc,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['CategoryID'] as int?,
      categoryDesc: json['Category_Desc'] as String?,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      categoryDesc: categoryDesc,
    );
  }
}
