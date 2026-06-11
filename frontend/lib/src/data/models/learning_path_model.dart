class LearningPathNode {
  final int id;
  final String title;
  final String status; // 'completed', 'current', 'locked'

  LearningPathNode({
    required this.id,
    required this.title,
    required this.status,
  });

  factory LearningPathNode.fromJson(Map<String, dynamic> json) {
    return LearningPathNode(
      id: json['id'],
      title: json['title'],
      status: json['status'],
    );
  }
}
