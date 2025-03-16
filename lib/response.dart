import 'package:flutter/foundation.dart' show immutable;

@immutable
class Response {
  final bool ok;
  final String message;

  const Response(this.message, this.ok);

  factory Response.ok() {
    return const Response("", true);
    }

  factory Response.error(String message) {
    return Response(message, false);
  }
}
