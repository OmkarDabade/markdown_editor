import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../src/constants.dart';
import '../src/emoji_input_formatter.dart';
import '../src/toolbar.dart';
import 'markdown_toolbar.dart';

class MarkdownAutoPreview extends StatefulWidget {
  const MarkdownAutoPreview({
    super.key,
    this.controller,
    this.scrollController,
    this.onChanged,
    this.style,
    this.onTap,
    this.cursorColor,
    this.toolbarBackground,
    this.expandableBackground,
    this.maxLines,
    this.minLines,
    this.markdownSyntax,
    this.emojiConvert = false,
    this.enableToolBar = true,
    this.showEmojiSelection = true,
    this.autoCloseAfterSelectEmoji = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.readOnly = false,
    this.expands = false,
    this.decoration = const InputDecoration(isDense: true),
    this.hintText,
    this.markdownPreviewBuilder,
    this.textFieldBuilder,
    this.shouldInitTextField = false,
  });

  /// Markdown syntax to reset the field to
  ///
  /// ## Headline
  /// - some text here
  ///
  final String? markdownSyntax;

  /// Hint text to show when the field is empty
  final String? hintText;

  /// For enable toolbar options
  ///
  /// if false, toolbar widget will not display
  final bool enableToolBar;

  /// Override the default markdown preview
  final Widget Function(String data)? markdownPreviewBuilder;

  /// Override the default text field
  final Widget Function(TextEditingController controller, FocusNode focusNode)?
      textFieldBuilder;

  /// If true by default, the TextField is shown
  final bool shouldInitTextField;

  /// Enable Emoji options
  ///
  /// if false, Emoji selection widget will not be displayed
  final bool showEmojiSelection;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  final ScrollController? scrollController;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  ///
  /// Defaults to [TextCapitalization.sentences]. Must not be null.
  ///
  /// See also:
  /// * [TextCapitalization], for a description of each capitalization behavior.
  final TextCapitalization textCapitalization;

  /// See also:
  ///
  /// * [inputFormatters], which are called before [onChanged] runs and can validate and change
  /// ("format") the input value.
  /// * [onEditingComplete], [onSubmitted]: which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the subtitle1 text style from the current [Theme].
  final TextStyle? style;

  /// to enable auto convert emoji
  ///
  /// if true, the string will be automatically converted to emoji
  ///
  /// example: :smiley: => 😃
  final bool emojiConvert;

  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap, to trigger focus
  /// requests, to move the caret, adjust the selection, etc. Handling some of those events by wrapping
  /// the text field with a competing GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's internal gesture
  /// detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be recognized.
  /// To be notified when the text field gains or loses the focus, provide a [focusNode] and add a
  /// listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the text field's internal gesture
  /// detector, use a [Listener].
  final VoidCallback? onTap;

  /// if you set it to false,
  /// the modal will not disappear after you select the emoji
  final bool autoCloseAfterSelectEmoji;

  /// Whether the text can be changed.
  ///
  /// When this is set to true, the text cannot be modified by any shortcut or keyboard operation. The text is still selectable.
  ///
  /// Defaults to false. Must not be null.
  final bool readOnly;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in the field.
  ///
  /// If this is null it will default to the ambient [TextSelectionThemeData.cursorColor]. If that is
  /// null, and the [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS] it will use
  /// [CupertinoThemeData.primaryColor]. Otherwise it will use the value of [ColorScheme.primary] of
  /// [ThemeData.colorScheme].
  final Color? cursorColor;

  /// The toolbar widget to display when the toolbar is enabled
  ///
  /// When no toolbarBackground widget is provided, the default toolbar color will be displayed
  /// which has grey[200] color
  ///
  ///
  final Color? toolbarBackground;

  /// The toolbar widget to display when the toolbar is enabled
  ///
  /// When no toolbarBackground widget is provided, the default toolbar color will be displayed
  /// which has white color
  ///
  ///
  final Color? expandableBackground;

  /// Customise the decoration of this text field
  /// Add label, hint etc
  final InputDecoration decoration;

  /// The maximum number of lines to show at one time, wrapping if necessary.
  ///
  /// This affects the height of the field itself and does not limit the number of lines that can be entered into the field.
  ///
  /// If this is 1 (the default), the text will not wrap, but will scroll horizontally instead.
  ///
  /// If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered, up to the height of its constraints.
  ///
  /// If this is not null, the value must be greater than zero, and it will lock the input to the given number of lines and take up enough horizontal space to accommodate that number of lines. Setting [minLines] as well allows the input to grow and shrink between the indicated range.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  ///
  /// This affects the height of the field itself and does not limit the number of lines that can be entered into the field.
  ///
  /// If this is null (default), text container starts with enough vertical space for one line and grows to accommodate additional lines as they are entered.
  ///
  /// This can be used in combination with [maxLines] for a varying set of behaviors.
  ///
  /// If the value is set, it must be greater than zero. If the value is greater than 1, [maxLines] should also be set to either null or greater than this value.
  ///
  /// When [maxLines] is set as well, the height will grow between the indicated range of lines. When [maxLines] is null, it will grow as high as needed, starting from [minLines].
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  ///
  /// If set to true and wrapped in a parent widget like [Expanded] or [SizedBox], the input will expand to fill the parent.
  ///
  /// [maxLines] and [minLines] must both be null when this is set to true, otherwise an error is thrown.
  ///
  /// Defaults to false.
  final bool expands;

  @override
  State<MarkdownAutoPreview> createState() => _MarkdownAutoPreviewState();
}

class _MarkdownAutoPreviewState extends State<MarkdownAutoPreview> {
  // Internal parameter
  late TextEditingController _internalController;

  final FocusScopeNode _internalFocus =
      FocusScopeNode(debugLabel: '_internalFocus');
  final FocusNode _textFieldFocusNode =
      FocusNode(debugLabel: '_textFieldFocusNode');

  late Toolbar _toolbar;

  bool _focused = false;

  @override
  void initState() {
    _internalController = widget.controller ?? TextEditingController();

    _toolbar = Toolbar(
      controller: _internalController,
      bringEditorToFocus: () {
        if (!_textFieldFocusNode.hasFocus) {
          setState(() {
            _focused = true;
          });

          _textFieldFocusNode.requestFocus();
        }
      },
    );

    _focused = widget.shouldInitTextField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB):
            BoldTextIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI):
            ItalicTextIntent(),
      },
      actions: {
        BoldTextIntent: CallbackAction<BoldTextIntent>(
          onInvoke: (intent) {
            _toolbar.action("**", "**");

            // onActionCompleted
            // setState(() {});
            return null;
          },
        ),
        ItalicTextIntent: CallbackAction<ItalicTextIntent>(
          onInvoke: (intent) {
            _toolbar.action("_", "_");

            // onActionCompleted
            // setState(() {});
            return null;
          },
        ),
      },

      onFocusChange: (focus) {
        setState(() {
          _focused = focus;
        });

        if (_focused) _internalFocus.requestFocus(_textFieldFocusNode);
      },
      // canRequestFocus: false,
      focusNode: _internalFocus,
      child: _focused
          ? _editorOnFocused()
          : GestureDetector(
              onTap: () {
                // Bring widget in widget tree first
                setState(() {
                  _focused = true;
                });

                // Then request for focus when widget is built
                _textFieldFocusNode.requestFocus();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Builder(builder: (context) {
                  final data = _internalController.text == ""
                      ? widget.hintText ?? "_Markdown text_"
                      : _internalController.text;
                  if (widget.markdownPreviewBuilder != null) {
                    return widget.markdownPreviewBuilder!(data);
                  }
                  return MarkdownBody(
                    key: const ValueKey<String>("zmarkdown-parse-body"),
                    data: data,
                  );
                }),
              ),
            ),
    );
  }

  Widget _editorOnFocused() {
    return !widget.enableToolBar
        ? _editor()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _editor(),

              // show toolbar
              if (!widget.readOnly)
                MarkdownToolbar(
                  markdownSyntax: widget.markdownSyntax,
                  // key: const ValueKey<String>("zmarkdowntoolbar"),
                  controller: _internalController,
                  autoCloseAfterSelectEmoji: widget.autoCloseAfterSelectEmoji,
                  toolbar: _toolbar,
                  onPreviewChanged: () {
                    // Remove focus first
                    _internalFocus.unfocus();

                    // Then remove widget from widget tree
                    setState(() {
                      _focused = !_focused;
                    });
                  },
                  unfocus: () {
                    _internalFocus.unfocus();
                  },
                  showEmojiSelection: widget.showEmojiSelection,
                  emojiConvert: widget.emojiConvert,
                  toolbarBackground: widget.toolbarBackground,
                  expandableBackground: widget.expandableBackground,
                )
            ],
          );
  }

  Widget _editor() {
    if (widget.textFieldBuilder != null) {
      return widget.textFieldBuilder!(_internalController, _textFieldFocusNode);
    }
    return TextField(
      controller: _internalController,
      focusNode: _textFieldFocusNode,
      cursorColor: widget.cursorColor,
      inputFormatters: [
        if (widget.emojiConvert) EmojiInputFormatter(),
      ],
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      scrollController: widget.scrollController,
      style: widget.style,
      textCapitalization: widget.textCapitalization,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      decoration: widget.decoration,
    );
  }
}
