String hideEmailAddress(String email) {
  String maskedEmail = email.replaceAllMapped(
      RegExp(r'(\w)\w*([.]?\w*)?(@\w+\.\w+)'),
          (match) {
        String maskedName = match.group(1)! + '*' * 5;
        String? maskedDomain = match.group(3);
        return maskedName + maskedDomain!;
      }
  );
  return maskedEmail;
}
