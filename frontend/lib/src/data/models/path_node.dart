class PathNode {
  final String title;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;

  PathNode(
    this.title, {
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLocked = true,
  });
}
