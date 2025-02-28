import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

// This is the entrypoint of our custom linter
PluginBase createPlugin() => _ExampleLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _ExampleLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        DxBlocLintCode(),
        AvoidPrint(),
      ];
}

class DxBlocLintCode extends DartLintRule {
  DxBlocLintCode() : super(code: _code);

  /// Metadata about the warning that will show-up in the IDE.
  /// This is used for `// ignore: code` and enabling/disabling the lint
  static const _code = LintCode(
    name: 'dixy_bloc_linter',
    problemMessage: 'BlocBuilder должен иметь явно указанный параметр bloc.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // Проверяем, что это вызов конструктора BlocBuilder
      final constructorName = node.constructorName;
      if (constructorName.name?.name == 'BlocBuilder') {
        final type = constructorName.type.type;
        if (type?.element?.name == 'BlocBuilder') {
          // Проверяем аргументы конструктора
          final argumentList = node.argumentList;
          final hasBlocParameter = argumentList.arguments.any((argument) {
            if (argument is NamedExpression) {
              return argument.name.label.name == 'bloc';
            }
            return false;
          });

          // Если параметр bloc не указан, сообщаем об ошибке
          if (!hasBlocParameter) {
            reporter.atNode(node, _code);
          }
        }
      }
    });
  }
}

class AvoidPrint extends DartLintRule {
  const AvoidPrint()
      : super(
          code: const LintCode(
            name: 'avoid_print',
            problemMessage: 'Avoid using print statements in production code. TESTIK',
            correctionMessage: 'Consider using a logger instead. TESTIK',
            url: 'https://doc.my-lint-rules.com/lints/avoid_print',
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Register a callback for each method invocation in the file.
    context.registry.addMethodInvocation((MethodInvocation node) {
      // We get the static element of the method name node.
      final Element? element = node.methodName.staticElement;

      // Check if the method's element is a FunctionElement.
      if (element is! FunctionElement) return;

      // Check if the method name is 'print'.
      if (element.name != 'print') return;

      // Check if the method's library is 'dart:core'.
      if (!element.library.isDartCore) return;

      // Report the lint error for the method invocation node.
      reporter.atNode(node, code);
    });
  }
}
