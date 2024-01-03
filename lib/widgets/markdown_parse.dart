import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:markdown/markdown.dart' as md;
import '../src/markdown_syntax.dart';
import 'image_network.dart';

typedef MarkdownTapTagCallback = void Function(String name, String fullText);

class MarkdownParse extends StatelessWidget {
  /// Creates a scrolling widget that parses and displays Markdown.
  const MarkdownParse({
    Key? key,
    required this.data,
    this.onTapLink,
    this.onTapHastag,
    this.onTapMention,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.syntaxHighlighter,
    this.bulletBuilder,
    this.styleSheetTheme,
    this.styleSheet,
    this.imageBuilder,
    this.checkboxBuilder,
    this.builders = const <String, MarkdownElementBuilder>{},
    this.selectable = false,
    this.inlineSyntaxes,
    this.blockSyntaxes,
    this.checkboxIconSize,
  }) : super(key: key);

  /// The string markdown to display.
  final String data;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? onTapLink;

  /// Called when the user taps a hashtag.
  final MarkdownTapTagCallback? onTapHastag;

  /// Called when the user taps a mention.
  final MarkdownTapTagCallback? onTapMention;

  /// How the scroll view should respond to user input.
  ///
  /// See also: [ScrollView.physics]
  final ScrollPhysics? physics;

  /// n object that can be used to control the position to which this scroll view is scrolled.
  ///
  /// See also: [ScrollView.controller]
  final ScrollController? controller;

  /// Whether the extent of the scroll view in the scroll direction should be determined by the contents being viewed.
  ///
  /// See also: [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// Creates a format [TextSpan] given a string.
  ///
  /// Used by [MarkdownWidget] to highlight the contents of `pre` elements.
  final SyntaxHighlighter? syntaxHighlighter;

  /// Signature for custom bullet widget.
  ///
  /// Used by [MarkdownWidget.bulletBuilder]
  final MarkdownBulletBuilder? bulletBuilder;

  /// Enum to specify which theme being used when creating [MarkdownStyleSheet]
  ///
  /// [material] - create MarkdownStyleSheet based on MaterialTheme
  /// [cupertino] - create MarkdownStyleSheet based on CupertinoTheme
  /// [platform] - create MarkdownStyleSheet based on the Platform where the
  /// is running on. Material on Android and Cupertino on iOS
  final MarkdownStyleSheetBaseTheme? styleSheetTheme;

  /// Defines which [TextStyle] objects to use for which Markdown elements.
  final MarkdownStyleSheet? styleSheet;

  /// Signature for custom image widget.
  ///
  /// Used by [MarkdownWidget.imageBuilder]
  final MarkdownImageBuilder? imageBuilder;

  /// Signature for custom checkbox widget.
  ///
  /// Used by [MarkdownWidget.checkboxBuilder]
  final MarkdownCheckboxBuilder? checkboxBuilder;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the current [bodytext2] font size.
  final double? checkboxIconSize;

  final Map<String, MarkdownElementBuilder> builders;
  final List<md.InlineSyntax>? inlineSyntaxes;
  final List<md.BlockSyntax>? blockSyntaxes;

  final bool selectable;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      key: key,
      // const Key("default-markdown-formatter"),
      data: data,
      selectable: selectable,
      padding: const EdgeInsets.all(8),
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      syntaxHighlighter: syntaxHighlighter,
      bulletBuilder: bulletBuilder ??
          (int number, BulletStyle style) {
            double? fontSize = Theme.of(context).textTheme.bodyMedium?.fontSize;
            return Text(
              "◉",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: (fontSize != null) ? fontSize + 2 : fontSize,
              ),
            );
          },
      styleSheetTheme: styleSheetTheme,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), md.AutolinkExtensionSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      blockSyntaxes: [const md.FencedCodeBlockSyntax(), if (blockSyntaxes != null) ...blockSyntaxes!],
      inlineSyntaxes: [ColoredHastagSyntax(), ColoredMentionSyntax(), if (inlineSyntaxes != null) ...inlineSyntaxes!],
      builders: {
        "hastag": ColoredHastagElementBuilder(onTapHastag),
        "mention": ColoredMentionElementBuilder(onTapMention),
        ...builders
      },
      styleSheet: styleSheet ??
          MarkdownStyleSheet(
            code: const TextStyle(
              color: Colors.purple,
            ),
            blockquoteDecoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(
                left: BorderSide(
                  color: Colors.grey,
                  width: 5,
                ),
              ),
            ),
            blockquotePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          ),
      onTapLink: onTapLink,
      imageBuilder: imageBuilder ??
          (Uri uri, String? title, String? alt) {
            return ImageNetworkMarkdown(
              uri: uri.toString(),
              title: title,
            );
          },
      checkboxBuilder: checkboxBuilder ??
          (bool value) {
            return FaIcon(
              value ? FontAwesomeIcons.solidSquareCheck : FontAwesomeIcons.square,
              size: checkboxIconSize ?? Theme.of(context).textTheme.bodyMedium?.fontSize,
              color: value ? Colors.blue[600] : Colors.grey,
            );
          },
    );
  }
}
