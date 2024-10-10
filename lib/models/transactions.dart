class Transactions {
  int? keyID;
  final String pName;
  final String fName;
  final String pDate;
  final int userAmount;
  final DateTime date;

  Transactions({
    this.keyID,
    required this.pName,
    required this.fName,
    required this.pDate,
    required this.userAmount,
    required this.date,
  });
}