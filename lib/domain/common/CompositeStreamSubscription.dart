import 'dart:async';

class CompositeStreamSubscription {
  final List<StreamSubscription> _subscriptions = [];

  CompositeStreamSubscription();

  void add(StreamSubscription subscription) => _subscriptions.add(subscription);

  void cancel() => _subscriptions.forEach((it) => it.cancel());
}
