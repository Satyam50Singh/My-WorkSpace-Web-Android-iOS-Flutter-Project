class TicketLocationCategoryEntity {
  final List<LocationDetailsEntity>? locationDetails;
  final List<CategoryEntity>? categoryDetails;

  const TicketLocationCategoryEntity({
    this.locationDetails,
    this.categoryDetails,
  });
}

class LocationDetailsEntity {
  final List<LocationEntity>? lastLocation;
  final List<LocationEntity>? favouriteLocation;
  final List<LocationEntity>? allLocation;

  const LocationDetailsEntity({
    this.lastLocation,
    this.favouriteLocation,
    this.allLocation,
  });
}

class LocationEntity {
  final int? locationId;
  final String? locationDesc;
  final bool? isLastLocation;

  final bool? isFavouriteLocation;

  final bool? isAllLocation;

  const LocationEntity({
    this.locationId,
    this.locationDesc,
    this.isLastLocation = false,
    this.isFavouriteLocation = false,
    this.isAllLocation = false,
  });
}

class CategoryEntity {
  final int? categoryId;
  final String? categoryDesc;

  const CategoryEntity({this.categoryId, this.categoryDesc});
}
