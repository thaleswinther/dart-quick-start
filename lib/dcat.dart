import 'dart:io';
import 'dart:convert';

class Task {
  bool? readFromInput;
  bool? showLineNumbers;
  List<String>? paths;

  Task(bool? readFromInput, bool? showLineNumbers, List<String>? paths) {
    this.readFromInput = readFromInput;
    this.showLineNumbers = showLineNumbers;
    this.paths = paths;
  }

  Future<void> dcat() async {
    exitCode = 0;

    if (readFromInput ?? false) {
      await stdin.pipe(stdout);
    } else {
      for (final path in paths ?? []) {
        var lineNumber = 1;
        final lines = utf8.decoder
            .bind(File(path).openRead())
            .transform(const LineSplitter());
        try {
          await for (final line in lines) {
            if (showLineNumbers ?? false) {
              stdout.write('${lineNumber++} ');
            }
            stdout.writeln(line);
          }
        } catch (_) {
          await _handleError(path);
        }
      }
    }
  }

  Future<void> _handleError(String path) async {
    if (await FileSystemEntity.isDirectory(path)) {
      stderr.writeln('error: $path is a directory');
    } else {
      exitCode = 2;
    }
  }
}

/*
import 'package:args/args.dart';
import 'package:dcat/dcat.dart';

const lineNumber = 'line-number';

void log(String txt) {
  print("${DateTime.now().toString()} : $txt");
}

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addFlag(lineNumber, negatable: false, abbr: 'n');
  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  final readFromInput = paths.isEmpty;

  final task = Task(readFromInput, argResults[lineNumber], paths);

  task.dcat(log);
}
 */

/*
import 'dart:io';
import 'dart:convert';

class Task {
  bool readFromInput;
  bool showLineNumbers;
  List<String> paths;

  Task(this.readFromInput, this.showLineNumbers, this.paths);

  Task.fromInput()
      : readFromInput = true,
        showLineNumbers = false,
        paths = [];

  Future<void> dcat(Function log) async {
    log("Job started!");
    exitCode = 0;

    if (readFromInput) {
      await stdin.pipe(stdout);
    } else {
      for (final path in paths) {
        var lineNumber = 1;
        final lines = utf8.decoder
            .bind(File(path).openRead())
            .transform(const LineSplitter());
        try {
          await for (final line in lines) {
            if (showLineNumbers) {
              stdout.write('${lineNumber++} ');
            }
            stdout.writeln(line);
          }
        } catch (_) {
          await _handleError(path);
        }
      }
    }

    log("Job completed!");
  }

  Future<void> _handleError(String path) async {
    if (await FileSystemEntity.isDirectory(path)) {
      stderr.writeln('error: $path is a directory');
    } else {
      exitCode = 2;
    }
  }
}
 */