import 'dart:io';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';


//Status can be implemented later
enum Status { started, paused, closed, undefined }

@immutable
class Exercise {
  final String id;
  final String name;
  final String description;
  final ExerciseData? exerciseData;
  

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    this.exerciseData,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      exerciseData: json['exerciseData'] == null
          ? null
          : ExerciseData.fromJson(json['exerciseData']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'exerciseData': exerciseData?.toJson(),
  };

  String serialize() {
    final json = toJson();
    final string = jsonEncode(json);
    return string;
  }

  factory Exercise.deserialize(String serialized) {
    return Exercise.fromJson(jsonDecode(serialized));
  }
}


class ExerciseData {
  final int repeats;
  final int restMin;
  final int antalSets;
  final double weight;

  ExerciseData({
   required this.repeats,
    required this.restMin,
    required this.antalSets,
    required this.weight,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      repeats: json['reapeats'],
      restMin: json['restMin'],
      antalSets: json['antalSets'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() => {
    'reapeats': repeats,
    'restMin': restMin,
    'antalSets': antalSets,
    'weight': weight,
  };
}


@immutable
class Workpass {
  final String id;
  final String name;
  final String description;
  final Map<Exercise, ExerciseData> exercises;


  Workpass({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
  });

  factory Workpass.fromJson(Map<String, dynamic> json) {
    Map<Exercise, ExerciseData> exercises = {};

    (json['exercises'] as Map<String, dynamic>).forEach((key, value) {
      exercises[Exercise.fromJson(jsonDecode(key))] = 
          ExerciseData.fromJson(value);
    });

    return Workpass(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      exercises: exercises,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'exercises': exercises.map((key, value) => MapEntry(
            jsonEncode(key.toJson()),
            value.toJson())),
      };

  String serialize() => jsonEncode(toJson());
  factory Workpass.deserialize(String serialized) {
    return Workpass.fromJson(jsonDecode(serialized));
  }

  addExercise(Exercise exercise, ExerciseData amount) {
    exercises[exercise] = amount;
  }

}


class WorkpassRepository {
  late Box<String> _workpassBox;

  WorkpassRepository() {
    // nit (petig) : användaren kanske själv vill konfigurera var datat ska sparas
    Directory directory = Directory.current;
    Hive.init(directory.path);
  }

  Future<void> initialize() async {
    // asynkron operation, tar obestämd (men snabb) tid att öppna vår datalagring.
    _workpassBox = await Hive.openBox('workpasss');
  }

  bool create(Workpass workpass) {
    if (!Hive.isBoxOpen("workpasss")) {
      throw StateError("Please await WorkpassRepository initialize method");
    }
    var existingWorkpass = _workpassBox.get(workpass.id);
    if (existingWorkpass != null) {
      return false;
    }
    _workpassBox.put(workpass.id, workpass.serialize());
    return true;
  }

  Workpass? read(String id) {
    var serialized = _workpassBox.get(id);
    return serialized != null ? Workpass.deserialize(serialized) : null;
  }

  Workpass update(Workpass workpass) {
    var existingWorkpass = _workpassBox.get(workpass.id);
    if (existingWorkpass == null) {
      throw Exception('Workpass not found');
    }
    _workpassBox.put(workpass.id, workpass.serialize());
    return workpass;
  }

  bool delete(String id) {
    var existingWorkpass = _workpassBox.get(id);
    if (existingWorkpass != null) {
      _workpassBox.delete(id);
      return true;
    }
    return false;
  }

  List<Workpass> list() => _workpassBox.values
      .map((serialized) => Workpass.deserialize(serialized))
      .toList();
}
