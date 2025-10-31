sealed class Failure {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

class LoadFailure extends Failure {
  const LoadFailure(super.msg);
}
