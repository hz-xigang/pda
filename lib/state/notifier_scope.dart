import 'package:flutter/material.dart';

/// 泛型基类，消除 InheritedNotifier<T> 的样板代码
class NotifierScope<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const NotifierScope({
    super.key,
    required T notifier,
    required super.child,
  }) : super(notifier: notifier);

  static S watch<S extends ChangeNotifier>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<NotifierScope<S>>();
    assert(scope != null, 'NotifierScope<$S> not found in context.');
    return scope!.notifier!;
  }

  static S read<S extends ChangeNotifier>(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<NotifierScope<S>>();
    final scope = element?.widget as NotifierScope<S>?;
    assert(scope != null, 'NotifierScope<$S> not found in context.');
    return scope!.notifier!;
  }
}
