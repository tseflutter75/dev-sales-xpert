class FormFilterField {
  final String label;
  final String column;
  final String placeholder;
  final int order;
  final bool active;

  FormFilterField({
    required this.label,
    required this.column,
    required this.placeholder,
    required this.order,
    required this.active,
  });

  factory FormFilterField.fromJson(Map<String, dynamic> json) {
    return FormFilterField(
      label: json['label'] ?? '',
      column: json['column'] ?? '',
      placeholder: json['placeholder'] ?? '',
      order: json['order'] ?? 0,
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'column': column,
      'placeholder': placeholder,
      'order': order,
      'active': active,
    };
  }
}