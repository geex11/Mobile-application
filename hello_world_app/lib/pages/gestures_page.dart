import 'package:flutter/material.dart';
import '../controllers/event_logger.dart';
import '../controllers/gesture_controller.dart';
import '../controllers/keyboard_controller.dart';
import '../controllers/input_validator.dart';

class GesturesPage extends StatefulWidget {
  const GesturesPage({super.key});

  @override
  State<GesturesPage> createState() => _GesturesPageState();
}

class _GesturesPageState extends State<GesturesPage> {
  final _logger = EventLogger();
  late final GestureController _gestureCtrl;
  late final KeyboardController _keyboardCtrl;
  final _validator = InputValidator();

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  String _gestureLabel = 'Interact with this area';
  IconData _gestureIcon = Icons.touch_app_outlined;
  Color _gestureColor = const Color(0xFF1565C0);

  @override
  void initState() {
    super.initState();
    _gestureCtrl = GestureController(_logger);
    _keyboardCtrl = KeyboardController(_logger);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _keyboardCtrl.onFocusGained();
      } else {
        _keyboardCtrl.onFocusLost();
      }
      _refresh();
    });
    _logger.log('📱 App started — waiting for input');
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _setGesture(String label, IconData icon, Color color, VoidCallback action) {
    action();
    setState(() {
      _gestureLabel = label;
      _gestureIcon = icon;
      _gestureColor = color;
    });
  }

  void _handleSwipe(DragEndDetails details) {
    final dx = details.velocity.pixelsPerSecond.dx;
    final dy = details.velocity.pixelsPerSecond.dy;
    if (dx.abs() > dy.abs()) {
      if (dx < -200) {
        _setGesture('Swipe Left — Previous Page', Icons.arrow_back,
            Colors.orange, _gestureCtrl.onSwipeLeft);
      } else if (dx > 200) {
        _setGesture('Swipe Right — Next Page', Icons.arrow_forward,
            Colors.green, _gestureCtrl.onSwipeRight);
      }
    } else {
      if (dy < -200) {
        _setGesture('Swipe Up — Scroll to Top', Icons.arrow_upward,
            Colors.purple, _gestureCtrl.onSwipeUp);
      } else if (dy > 200) {
        _setGesture('Swipe Down — Refresh', Icons.arrow_downward,
            Colors.teal, _gestureCtrl.onSwipeDown);
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _keyboardCtrl.onKeySubmit(_textController.text);
      _textController.clear();
      _focusNode.unfocus();
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted successfully'),
          backgroundColor: Color(0xFF1565C0),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLongPressMenu() {
    _gestureCtrl.onLongPress();
    setState(() {
      _gestureLabel = 'Long Press — Context Menu';
      _gestureIcon = Icons.menu_open;
      _gestureColor = Colors.deepPurple;
    });
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Context Menu',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 12),
            _menuItem(Icons.share, 'Share', ctx),
            _menuItem(Icons.copy, 'Copy', ctx),
            _menuItem(Icons.delete_outline, 'Delete', ctx),
            _menuItem(Icons.info_outline, 'Info', ctx),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, BuildContext ctx) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1565C0)),
      title: Text(label),
      onTap: () {
        _logger.log('📌 Context menu: "$label" selected');
        Navigator.pop(ctx);
        _refresh();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Input & Gestures',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            tooltip: 'Clear log',
            onPressed: () {
              _logger.clear();
              _logger.log('🗑️ Event log cleared');
              _refresh();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── GESTURE ZONE ─────────────────────────────────────────────
            _sectionHeader(Icons.touch_app, 'Touch Gesture Handling'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _setGesture(
                  'Tap detected', Icons.touch_app, const Color(0xFF1565C0),
                  _gestureCtrl.onTap),
              onDoubleTap: () => _setGesture(
                  'Double Tap detected', Icons.ads_click, Colors.indigo,
                  _gestureCtrl.onDoubleTap),
              onLongPress: _showLongPressMenu,
              onPanEnd: _handleSwipe,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: _gestureColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: _gestureColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_gestureIcon, size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(_gestureLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                        'Tap · Double Tap · Long Press · Swipe',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            // Gesture hint row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _gestureHint(Icons.touch_app, 'Tap'),
                _gestureHint(Icons.ads_click, 'Double'),
                _gestureHint(Icons.menu_open, 'Long\nPress'),
                _gestureHint(Icons.swap_horiz, 'Swipe'),
              ],
            ),

            const SizedBox(height: 24),

            // ── KEYBOARD INPUT ────────────────────────────────────────────
            _sectionHeader(Icons.keyboard, 'Keyboard Input Handling'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 6,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Username Input',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D47A1))),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _textController,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Type a username...',
                        prefixIcon: const Icon(Icons.person_outline,
                            color: Color(0xFF1565C0)),
                        filled: true,
                        fillColor: const Color(0xFFF5F9FF),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue.shade200)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue.shade200)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF1565C0), width: 2)),
                      ),
                      onChanged: (text) {
                        _keyboardCtrl.onTextChanged(text);
                        _refresh();
                      },
                      onFieldSubmitted: (_) => _submitForm(),
                      validator: _validator.validateUsername,
                    ),
                    const SizedBox(height: 8),

                    // Live validation feedback
                    if (_textController.text.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _validator
                                      .validateUsername(_textController.text) ==
                                  null
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _validator.validateUsername(
                                        _textController.text) ==
                                    null
                                ? Colors.green.shade300
                                : Colors.red.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _validator.validateUsername(
                                          _textController.text) ==
                                      null
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              size: 16,
                              color: _validator.validateUsername(
                                          _textController.text) ==
                                      null
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _validator
                                  .getValidationResult(_textController.text),
                              style: TextStyle(
                                fontSize: 12,
                                color: _validator.validateUsername(
                                            _textController.text) ==
                                        null
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text('Submit (Enter)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── EVENT LOG ─────────────────────────────────────────────────
            _sectionHeader(Icons.list_alt, 'Event Log'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 6,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: _logger.events.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('No events yet. Interact with the app!',
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 13)),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _logger.events.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (ctx, i) {
                        final event = _logger.events[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Text(
                            event,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: i == 0
                                  ? const Color(0xFF0D47A1)
                                  : Colors.blueGrey.shade700,
                              fontWeight: i == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0D47A1), size: 20),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1))),
      ],
    );
  }

  Widget _gestureHint(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1565C0)),
        const SizedBox(height: 2),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
      ],
    );
  }
}
