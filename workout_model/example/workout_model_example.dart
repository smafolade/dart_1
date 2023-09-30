import 'package:workout_model/workout_model.dart';

void main() async {
  // Initialize a WorkpassRepository
  WorkpassRepository repository = WorkpassRepository();

  await repository.initialize();

  // Create a few exercises
  Exercise pushUpExercise =
      Exercise(id: "101", name: "pushup", description: "vanliga pushups");
  Exercise rowingExercise =
      Exercise(id: "102", name: "rodd", description: "rodd 1000 m level 5");
  Exercise bicepsExercise =
      Exercise(id: "103", name: "biceps", description: "biceps träning med 1 kg");

  // Print out the exercises's name
  print(pushUpExercise.name);

  // Create a Workpass
  Workpass everyDayWorkpass = Workpass(
      id: "001",
      name: "every day Workpass",
      description: "Workpass för varje dag",
      exercises: {});

  // Print out the workpass's name
  print(everyDayWorkpass.name);

  // Use the WorkpassEditingManager to start editing the workpass

  // Add exercises and their amounts to the workpass
  everyDayWorkpass.addExercise(pushUpExercise,
      ExerciseData(repeats: 10, restMin: 2, antalSets: 3, weight: 0));
  everyDayWorkpass.addExercise(rowingExercise, 
      ExerciseData(repeats: 10, restMin: 2, antalSets: 3, weight: 0));
  everyDayWorkpass.addExercise(bicepsExercise, 
      ExerciseData(repeats: 10, restMin: 2, antalSets: 3, weight: 1));

  
  // Finish editing

  // Use the WorkpassRepository to store the workpass
  bool isCreated = repository.create(everyDayWorkpass);
  print('Workpass added to repository: $isCreated');

  // Read it back
  Workpass? readWorkpass = repository.read("001");
  print('Read workpass description: ${readWorkpass?.description}');

  // Update it
  Workpass updatedWorkpass = Workpass(
      id: "001",
      name: "Updated Everyday Workpass",
      description: "Workpass för varje dag",
      exercises: {});
  Workpass updatedVersion = repository.update(updatedWorkpass);
  print('Updated workpass description: ${updatedVersion.description}');

  // List all the workpass in the repository
  List<Workpass> allWorkpasss = repository.list();
  print('Number of workpasses in repository: ${allWorkpasss.length}');

  bool isDeleted = repository.delete(everyDayWorkpass.id);
  print('Workpass deleted from repository: $isDeleted');

}