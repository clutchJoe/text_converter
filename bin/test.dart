import 'dart:convert';
import 'dart:io';
import 'package:dcli/dcli.dart';

void main(List<String> args) async {
  var argParser = ArgParser();
  argParser.addFlag('parser', abbr: 'p', defaultsTo: false, negatable: false);
  argParser.addFlag('stringify', abbr: 's', defaultsTo: false, negatable: false);

  var results = argParser.parse(args);
  var parser = results['parser'] as bool;
  var stringify = results['stringify'] as bool;

  if (!parser && !stringify) {
    print(red('You must pass the name of the executable to search for.'));
    print(green('Usage:'));
    print(green(argParser.usage));
    exit(1);
  }

  if (parser) {
    print(blue('Parsing text form your clipboard...'));
    var output = jsonDecode(await pasteFromClipboard());
    print(green('Copy the converted text to your clipboard!'));
    // 'echo $output | pbcopy'.run;
    await copyToClipboard(output);
    print(output);
  } else if (stringify) {
    print(blue('Stringifying text form your clipboard...'));
    var output = jsonEncode(await pasteFromClipboard());
    print(green('Copy the converted text to your clipboard!'));
    await copyToClipboard(output);
    print(output);
  }
}

Future copyToClipboard(String str) async {
  var process = await Process.start('pbcopy', []);
  process.stdout.transform(utf8.decoder);
  process.stdin.write(str);
  process.stdin.close();
}

Future<String> pasteFromClipboard() async {
  // var input = '';
  // 'pbpaste'.forEach((line) {
  //   input += input != '' ? '\n$line' : line;
  // });
  // return input;
  var result = await Process.run('pbpaste', []);
  return result.stdout;
}
