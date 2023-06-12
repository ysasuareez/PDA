/// Represents an employee model.
class Employee {
  final String id;
  final String name;
  final String birthDate;
  final String dni;
  final String salary;
  final int pin;

  Employee({
    required this.id,
    required this.name,
    required this.pin,
    required this.birthDate,
    required this.dni,
    required this.salary,
  });
}
