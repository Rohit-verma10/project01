import 'package:flutter/material.dart';

const _assistantInk = Color(0xFF173D2A);
const _assistantGreen = Color(0xFF2E7D4F);

class _ChatMessage {
  const _ChatMessage({required this.text, required this.fromUser});

  final String text;
  final bool fromUser;
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
      text: 'Hello! I can share general guidance about crop care, irrigation, soil, and planning. What would you like help with?',
      fromUser: false,
    ),
  ];
  bool _sending = false;

  static const _suggestions = [
    'How can I check crop health?',
    'Tips to save irrigation water',
    'How do I plan for harvest?',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send([String? suggestedText]) async {
    final text = (suggestedText ?? _inputController.text).trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, fromUser: true));
      _inputController.clear();
      _sending = true;
    });
    _scrollToBottom();

    // This local prototype uses short, topic-based guidance. Connect an AI API
    // here when the project has a backend and credentials configured.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    final answer = _localAnswer(text);
    setState(() {
      _messages.add(_ChatMessage(text: answer, fromUser: false));
      _sending = false;
    });
    _scrollToBottom();
  }

  String _localAnswer(String prompt) {
    final question = prompt.toLowerCase();
    if (_hasAny(question, ['disease', 'spot', 'yellow', 'wilting', 'pest', 'leaf'])) {
      return 'For a first check, look at several plants across the field and note whether symptoms are spreading. Take clear photos and record when you first noticed the change. Avoid applying a treatment based on one symptom alone; a local agriculture expert can help confirm the cause.';
    }
    if (_hasAny(question, ['water', 'irrigat', 'rain', 'dry'])) {
      return 'To use water carefully, check soil moisture near the root zone before irrigating, look for leaks or blocked emitters, and water at cooler times when practical. The right schedule depends on your crop, soil, and local weather.';
    }
    if (_hasAny(question, ['soil', 'fertili', 'nutrient', 'compost'])) {
      return 'A soil test is the best starting point for fertilizer decisions. Keep notes on previous crops and inputs, and follow recommendations for your crop and region. Adding organic matter can support soil structure over time.';
    }
    if (_hasAny(question, ['yield', 'harvest', 'production', 'crop'])) {
      return 'Harvest planning depends on crop variety, sowing date, field condition, and local weather. Track crop growth across several parts of the field and compare with guidance from your local extension service. The Yield Prediction tool can also give a rough planning estimate.';
    }
    if (_hasAny(question, ['weather', 'forecast', 'rainfall', 'temperature'])) {
      return 'Check a current local forecast before field work, especially ahead of spraying, irrigation, or harvest. Weather can vary over short distances, so treat a general forecast as guidance and keep an eye on conditions at your farm.';
    }
    return 'I can help with general questions about crop health, irrigation, soil care, weather planning, and harvest preparation. Try asking about one of those topics. For crop-specific diagnosis or treatment, consult a local agriculture expert.';
  }

  bool _hasAny(String text, List<String> words) => words.any(text.contains);

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    _buildNotice(wide),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 16, vertical: 18),
                        itemCount: _messages.length + (_sending ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_sending && index == _messages.length) {
                            return const _TypingIndicator();
                          }
                          return _MessageBubble(message: _messages[index]);
                        },
                      ),
                    ),
                    if (_messages.length == 1 && !_sending) _buildSuggestions(wide),
                    _buildComposer(wide),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotice(bool wide) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(wide ? 24 : 16, 12, wide ? 24 : 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3E9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _assistantGreen, size: 18),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Demo assistant · replies are local examples, not live AI advice.',
              style: TextStyle(color: _assistantInk, fontSize: 11, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(bool wide) {
    return Padding(
      padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 0, wide ? 24 : 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions.map((suggestion) {
            return ActionChip(
              label: Text(suggestion),
              onPressed: () => _send(suggestion),
              avatar: const Icon(Icons.arrow_outward_rounded, size: 15),
              labelStyle: const TextStyle(fontSize: 12, color: _assistantInk),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFDDE6DA)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildComposer(bool wide) {
    return Container(
      padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 12, wide ? 24 : 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5EAE3))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              onSubmitted: (_) => _send(),
              decoration: InputDecoration(
                hintText: 'Ask about your farm…',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                filled: true,
                fillColor: const Color(0xFFF5F7F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          IconButton.filled(
            tooltip: 'Send message',
            onPressed: _sending ? null : _send,
            style: IconButton.styleFrom(
              backgroundColor: _assistantGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 48),
            ),
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final user = message.fromUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * (MediaQuery.sizeOf(context).width >= 760 ? 0.68 : 0.82),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: user ? _assistantGreen : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(19),
              topRight: const Radius.circular(19),
              bottomLeft: Radius.circular(user ? 19 : 5),
              bottomRight: Radius.circular(user ? 5 : 19),
            ),
            border: user ? null : Border.all(color: const Color(0xFFE4EAE2)),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: user ? Colors.white : _assistantInk, height: 1.45, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4EAE2)),
        ),
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: _assistantGreen),
        ),
      ),
    );
  }
}
