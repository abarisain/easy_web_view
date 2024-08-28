extension StringUtils on String {
  bool get isValidHtml => this.contains('<html>') && this.contains('</html>');

  bool get isValidUrl =>
      this.startsWith('https://') ||
      this.startsWith('http://') ||
      this.startsWith('/');

  bool get isValidMarkdown => !isValidUrl && !isValidHtml;

  String wrapHtml({
    String title = 'Document',
    String pad = '    ',
  }) {
    final sb = StringBuffer();
    final add = (String s) => sb.writeln(s);
    add('<!DOCTYPE html>');
    add('<html lang="en">');
    add('<head>');
    add('$pad<meta charset="UTF-8">');
    add('$pad<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    add('$pad<title>${title}</title>');
    add('</head>');
    add('<body>');
    add(this);
    add('</body>');
    add('</html>');
    return sb.toString();
  }
}
