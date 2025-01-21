class AccountDto {
  final String id;
  final String name;
  final double balance;
  final String currency;
  final DateTime createdDate;
  // final icon icon;

  AccountDto({
    required this.id,
    required this.name, 
    this.balance = 0.0,
    this.currency = 'USD',
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    return AccountDto(
      id: json['id'],
      name: json['name'],
      balance: json['balance'], 
      currency: json['currency'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}