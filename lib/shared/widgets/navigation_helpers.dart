import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void navigateBack(BuildContext context, String fallback) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}

void openTranslationDestination(BuildContext context, String route) {
  if (route == '/translate') {
    context.go(route);
  } else if (GoRouterState.of(context).uri.path != route) {
    context.push(route);
  }
}
