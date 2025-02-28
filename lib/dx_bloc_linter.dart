import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _DxBlocLinter();

class _DxBlocLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        BlocParameterBlocBuilderLintCode(),
        BlocParameterBlocListenerLintCode(),
        BlocParameterBlocConsumerLintCode(),
        BlocProviderLintCode(),
      ];
}

class BlocParameterBlocBuilderLintCode extends DartLintRule {
  const BlocParameterBlocBuilderLintCode()
      : super(
          code: const LintCode(
            name: 'bloc_parameter_bloc_builder',
            problemMessage: 'BlocBuilder должен иметь явно указанный параметр bloc.',
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.type?.element?.name == 'BlocBuilder') {
        final argumentList = node.argumentList;
        final hasBlocParameter = argumentList.arguments.any((argument) {
          if (argument is NamedExpression) {
            return argument.name.label.name == 'bloc';
          }
          return false;
        });

        if (!hasBlocParameter) {
          reporter.atNode(node, code);
        }
      }
    });
  }
}

class BlocParameterBlocListenerLintCode extends DartLintRule {
  const BlocParameterBlocListenerLintCode()
      : super(
          code: const LintCode(
            name: 'bloc_parameter_bloc_listener',
            problemMessage: 'BlocListener должен иметь явно указанный параметр bloc.',
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.type?.element?.name == 'BlocListener') {
        final argumentList = node.argumentList;
        final hasBlocParameter = argumentList.arguments.any((argument) {
          if (argument is NamedExpression) {
            return argument.name.label.name == 'bloc';
          }
          return false;
        });

        if (!hasBlocParameter) {
          reporter.atNode(node, code);
        }
      }
    });
  }
}

class BlocParameterBlocConsumerLintCode extends DartLintRule {
  const BlocParameterBlocConsumerLintCode()
      : super(
          code: const LintCode(
            name: 'bloc_parameter_bloc_consumer',
            problemMessage: 'BlocConsumer должен иметь явно указанный параметр bloc.',
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.type?.element?.name == 'BlocConsumer') {
        final argumentList = node.argumentList;
        final hasBlocParameter = argumentList.arguments.any((argument) {
          if (argument is NamedExpression) {
            return argument.name.label.name == 'bloc';
          }
          return false;
        });

        if (!hasBlocParameter) {
          reporter.atNode(node, code);
        }
      }
    });
  }
}

class BlocProviderLintCode extends DartLintRule {
  const BlocProviderLintCode()
      : super(
          code: const LintCode(
            name: 'bloc_provider',
            problemMessage: 'BlocProvider не должен использоваться.',
            errorSeverity: ErrorSeverity.WARNING,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.type?.element?.name == 'BlocProvider') {
        reporter.atNode(node, code);
      }
    });
  }
}
