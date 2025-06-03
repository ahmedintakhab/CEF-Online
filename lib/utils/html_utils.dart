import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

String convertHtmlToPlainText(String htmlText) {
  // Parse the HTML string
  final document = html_parser.parse(htmlText);

  // Recursive function to extract text from nodes
  String extractText(html_dom.Node node) {
    if (node is html_dom.Text) {
      // Return trimmed text, removing excessive whitespace
      return node.text.trim();
    } else if (node is html_dom.Element) {
      // Handle specific elements
      final tag = node.localName?.toLowerCase();
      final childrenText = node.nodes.map((child) => extractText(child)).where((text) => text.isNotEmpty).toList();

      // Add separators for specific tags
      if (tag == 'li') {
        // Prefix list items with a bullet and end with a newline
        return childrenText.isNotEmpty ? '• ${childrenText.join(' ')}\n' : '';
      } else if (tag == 'p' || tag == 'div' || tag == 'section' || tag == 'header' || tag == 'footer') {
        // Add newline after paragraphs, divs, sections, headers, footers
        return childrenText.isNotEmpty ? '${childrenText.join(' ')}\n' : '';
      } else if (tag == 'br') {
        // Add newline for <br> tags
        return '\n';
      } else if (tag == 'a') {
        // For links, return the text content (ignore href)
        return childrenText.join(' ');
      } else if (tag == 'style' || tag == 'script') {
        // Ignore <style> and <script> tags
        return '';
      } else {
        // For other tags, join children text without additional formatting
        return childrenText.join(' ');
      }
    }
    return '';
  }

  // Extract text from the document body
  final plainText = document.body?.nodes.map((node) => extractText(node)).where((text) => text.isNotEmpty).join('') ?? '';

  // Clean up: remove extra newlines and spaces
  return plainText.replaceAll(RegExp(r'\n\s*\n+'), '\n').trim();
}