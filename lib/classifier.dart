//this is the tutorial i have been following
// https://medium.com/@am15hg/text-classification-using-tensorflow-lite-plugin-for-flutter-3b92f6655982

//this package is necessary if I am running tests, but i gotta include this package in the pubspec.yaml https://docs.flutter.dev/cookbook/testing/integration/introduction
// import 'package:test/test.dart';

import "package:flutter/services.dart";

// Import tflite_flutter
import "package:tflite_flutter/tflite_flutter.dart";

class Classifier {
  //Here, I am creating a variable for the name of my file, which is vocab file, situated in assets
  String _vocabFile = 'assets/final_text_classifier_vocabulary.txt';
  String _modelFile = 'assets/text_classifier.tflite';

  // TensorFlow Lite Interpreter object
  Interpreter _interpreter;

  //I think this is the default size for the text in my model
  final int _sentenceLen = 128;

  //THis will be for the symbols that i see.
  final String start = '[PAD]';
  final String pad = '[PAD]';
  final String unk = '[unused0]';

  //Here, I am creating a map, to the right,there is the index of the the value, and to the left, there is the string itself
  Map<String, int> _dict;

  //JUst like in C++, this is the class constructor, meaning that everytime someone calls this class, the function _loadDictionary() will be runned
  Classifier() {
    // Load model when the classifier is initialized.
    _loadModel();
    _loadDictionary();
    //_getInfo();
  }

// I created a function that get the information about the necessary inputs for the ml program

  void _getInfo() {
    _interpreter.allocateTensors();
// Print list of input tensors
    print(_interpreter.getInputTensors());
// Print list of output tensors
    print(_interpreter.getOutputTensors());
  }

  void _loadDictionary() async {
    print("yes");
    final vocab = await rootBundle.loadString('assets/$_vocabFile');
    var dict = <String, int>{};
    final vocabList = vocab.split('\n');
    for (var i = 0; i < vocabList.length; i++) {
      var entry = vocabList[i].trim().split(' ');
      dict[entry[0]] = int.parse(entry[1]);
    }
    _dict = dict;
    print('Dictionary loaded successfully');
  }

//let's hope this guy is right https://stackoverflow.com/questions/51341055/loading-a-file-using-rootbundle
  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    print("Hlleo");
    _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');
  }

  //HEre, i am just creating a function that will return a two-dimension list for my input
  List<List<double>> tokenizeInputText(String text) {
    // Whitespace tokenization
    final toks = text.split(' ');

    // Create a list of length==_sentenceLen filled with the value <pad>
    var vec = List<double>.filled(_sentenceLen, _dict[pad].toDouble());

    var index = 0;
    if (_dict.containsKey(start)) {
      vec[index++] = _dict[start].toDouble();
    }

    // For each word in sentence find corresponding index in dict
    for (var tok in toks) {
      if (index > _sentenceLen) {
        break;
      }
      vec[index++] = _dict.containsKey(tok)
          ? _dict[tok].toDouble()
          : _dict[unk].toDouble();
    }

    // returning List<List<double>> as our interpreter input tensor expects the shape, [1,256]
    return [vec];
  }
}
