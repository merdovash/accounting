T safe_cast<T>(v, T defaultValue) {
  if (v is T) {
    return v;
  }
  return defaultValue;
}