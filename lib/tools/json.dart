Map<String, dynamic> startsWith(Map<String, dynamic> json, String prefix) {
  Map<String, dynamic> result = new Map();
  json.forEach((key, value) {
    if (key.startsWith(prefix)) {
      result[key] = value;
    }
  });
  return result;
}