part of twilio_programmable_chat;

class MessageOptions {
  //#region Private API properties
  String _body;

  Map<String, dynamic> _attributes;

  File _input;

  String _mimeType;

  String _filename;

  int _mediaProgressListenerId;
  //#endregion

  //#region Public API methods
  /// Create message with given body text.
  ///
  /// If you specify [MessageOptions.withBody] then you will not be able to specify [MessageOptions.withMedia] because they are mutually exclusive message types.
  /// Created message type will be [MessageType.TEXT].
  void withBody(String body) {
    assert(body != null);
    if (_input != null) {
      throw Exception('MessageOptions.withMedia has already been specified');
    }
    _body = body;
  }

  /// Set new message attributes.
  void withAttributes(Map<String, dynamic> attributes) {
    _attributes = attributes;
  }

  /// Create message with given media stream.
  ///
  /// If you specify [MessageOptions.withMedia] then you will not be able to specify [MessageOptions.withBody] because they are mutually exclusive message types. Created message type will be [MessageType.MEDIA].
  void withMedia(File input, String mimeType) {
    assert(input != null);
    assert(mimeType != null);
    if (_body != null) {
      throw Exception('MessageOptions.withBody has already been specified');
    }
    _input = input;
    _mimeType = mimeType;
  }

  /// Provide optional filename for media.
  void withMediaFileName(String filename) {
    assert(filename != null);
    _filename = filename;
  }

  void withMediaProgressListener({
    void Function() onStarted,
    void Function(int bytes) onProgress,
    void Function(String mediaSid) onCompleted,
  }) {
    _mediaProgressListenerId = DateTime.now().millisecondsSinceEpoch;
    TwilioProgrammableChat._mediaProgressChannel.receiveBroadcastStream().listen((dynamic event) {
      var eventData = Map<String, dynamic>.from(event);
      if (eventData['mediaProgressListenerId'] == _mediaProgressListenerId) {
        switch (eventData['name']) {
          case 'started':
            if (onStarted != null) {
              onStarted();
            }
            break;
          case 'progress':
            if (onProgress != null) {
              onProgress(eventData['data'] as int);
            }
            break;
          case 'completed':
            if (onCompleted != null) {
              onCompleted(eventData['data'] as String);
            }
            break;
        }
      }
    });
  }
  //#endregion

  /// Create map from properties.
  Map<String, dynamic> toMap() {
    return {
      'body': _body,
      'attributes': _attributes,
      'input': _input?.path,
      'mimeType': _mimeType,
      'filename': _filename,
      'mediaProgressListenerId': _mediaProgressListenerId,
    };
  }
}
