class Task {
  final String title; // A feladat neve
  final String deadline; // Határidő
  final String priority; // Prioritás (Magas, Közepes, Alacsony)
  bool isCompleted; // Teljesítve van-e
  final List<Subtask> subtasks; // Részfeladatok listája

  Task({
    required this.title,
    required this.deadline,
    required this.priority,
    this.isCompleted = false,
    required this.subtasks,
  });
}

class Subtask {
  final String title; // Részfeladat neve
  bool isCompleted; // Teljesítve van-e

  Subtask({
    required this.title,
    this.isCompleted = false,
  });
}
