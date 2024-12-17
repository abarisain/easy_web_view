extension StringUtils on String {
  bool get isValidHtml => this.contains('<html>') && this.contains('</html>');

  bool get isValidUrl =>
      this.startsWith('https://') ||
      this.startsWith('http://') ||
      this.startsWith('/');
}
