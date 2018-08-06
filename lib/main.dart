void main() {
  var result = "test.png".splitMapJoin(
    ".",
    onMatch: (m) {
      m.group(0);
      return "Dot";
    },
    onNonMatch: (m) {
      return m.toUpperCase();
    },
  );
  print(result);
}
