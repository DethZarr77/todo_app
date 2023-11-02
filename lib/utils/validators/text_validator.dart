Function textValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  if (value.length < 3) {
    return 'Please enter at least 3 characters';
  }
  return null;
};
