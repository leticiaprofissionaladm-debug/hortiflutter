class OrderModel {
  int id;
  double total;

  OrderModel({required this.id, required this.total});

  factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      id: json["id"], 
      total: double.parse(json["total"].toString()));
  }
}