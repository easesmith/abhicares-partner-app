class ServiceModel {
  int serviceId;
  String name;
  int startingPrice;
  String description;
  int catId;
  String imageUrl;
  ServiceModel({
    required this.serviceId,
    required this.imageUrl,
    required this.startingPrice,
    required this.catId,
    required this.name,
    required this.description,
  });
}
