import 'package:workout_model/workout_model.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final repository = WorkpassRepository();

    setUp(() async {
       await repository.initialize();
    });

    test('Create Exercise', () {
      Exercise exercise =
          Exercise(id: "200", name: "High Knees", description: "Höga knän");
      expect(exercise, isNotNull);
    });

    test('Edit Workpass', () {
      Workpass workpass = Workpass(
          id: "001",
          name: "workpass för varje dag",
          description: "enkla övningar för varje dag",
          exercises: {});
      Exercise highKnees =
          Exercise(id: "200", name: "High Knees", description: "Höga knän");
      workpass.addExercise(
          highKnees, ExerciseData(repeats: 10, restMin: 2, antalSets: 3, weight: 0));
      
      // Check that the manager's current workpass is the same as our workpass
      expect(workpass.id, equals(workpass.id));
      expect(workpass.name, equals(workpass.name));
      expect(workpass.description, equals(workpass.description));

      // Check the exercises were added correctly
      var highKneesAmount = workpass.exercises[highKnees];
      expect(highKneesAmount?.repeats, equals(10));
      expect(highKneesAmount?.restMin, equals(2));
      expect(highKneesAmount?.antalSets, equals(3));
      expect(highKneesAmount?.weight, equals(0));
    });

    test('Add Workpass to Repository', () {
      var workpass = Workpass(
          id: "002",
          name: "situps",
          description: "enkla situps",
          exercises: {});
      bool result = repository.create(workpass);
      expect(result, isTrue);
    });

    test('Read Workpass from Repository', () {
      var workpass = repository.read("002");
      expect(workpass?.id, equals("002"));
      expect(workpass?.name, equals("situps"));
      expect(workpass?.description, equals("enkla situps"));
    });

    test('Update Workpass in Repository', () {
      var updatedWorkpass = Workpass(
          id: "002",
          name: "situps",
          description: "mycket enkla situps",
          exercises: {});
      var returnedWorkpass = repository.update(updatedWorkpass);
      expect(returnedWorkpass.description, equals("mycket enkla situps"));
    });

    test('Delete Workpass from Repository', () {
      bool deleted = repository.delete("002");
      expect(deleted, isTrue);
      var workpass = repository.read("002");
      expect(workpass, isNull);
    });

  });
}
