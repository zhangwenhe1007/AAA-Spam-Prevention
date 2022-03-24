class Messages {
  final String number;
  final String result_number;
  final String result_message;
  final String message;

  //this represents the number of times the number was marked as a spam, it will be changed on the server, not on the phone, so final
  //Rating can be modified by the user, we do not use final
  int rating_number;
  int rating_sms;

  Messages({
    this.number,
    this.result_number,
    this.result_message,
    this.rating_number,
    this.rating_sms,
    this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'result_number': result_number,
      'result_message': result_message,
      'ratingNumber': rating_number,
      'ratingSMS': rating_sms,
      'message': message,
    };
  }

  // Implement toString to make it easier to see information about
  // each number when using the print statement.
  @override
  String toString() {
    return 'Messages{number: $number, message: $message, result_number: $result_number, result_message: $result_message, rating_number: $rating_number, rating_sms: $rating_sms}';
  }
}
