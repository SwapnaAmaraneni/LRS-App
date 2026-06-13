class QuestionnaireResponse {
  final String? sno;
   String? selectedAnswer;
   String? document;
   String? checkDRopDown;
   String? remarks;

  QuestionnaireResponse({
    required this.sno,
    this.selectedAnswer,
    this.document,
    this.checkDRopDown,
    this.remarks,
  });



  Map<String, dynamic> toJson() {
    return {
      'sno': sno,
      'selectedAnswer': selectedAnswer,
      'document': document,
      'checkDRopDown': checkDRopDown,
      'remarks': remarks,
    };
  }
}