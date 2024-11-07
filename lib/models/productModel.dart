// class ProductModel {
//   String imageUrl;
//   String size;
//   int price;
//   int quantity;
//   String title;
//   String? description;
//   ProductModel(
//       {required this.imageUrl,
//       required this.price,
//       required this.size,
//       required this.quantity,
//       required this.title,
//       this.description});
// }
class ProductModel {
  String name;
  int price;
  int offerPrice;
  String description;
  int serviceId;
  ProductModel({
    required this.name,
    required this.price,
    required this.offerPrice,
    required this.description,
    required this.serviceId,
  });
}
