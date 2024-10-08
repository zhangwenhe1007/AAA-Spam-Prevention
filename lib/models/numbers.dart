class Numbers {
  final String number;
  final String result;
  //Rating can be modified by the user, do we do not use final
  int rating;
  int times_marked;

  Numbers({
    this.number,
    this.result,
    this.rating,
    this.times_marked,
  });

  //This method is included inside the Numbers class. It is a method of the class.
  //The return value is a map (dictionary) with the instance fields of the class
  // Convert a Numbers into a Map. The keys must correspond to the phone number of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'number': number, 'result': result, 'rating': rating, 'times_marked': times_marked};
  }

  // Implement toString to make it easier to see information about
  // each number when using the print statement.
  @override
  String toString() {
    return 'Numbers{number: $number, result: $result, rating: $rating, was_marked: $times_marked}';
  }
}
