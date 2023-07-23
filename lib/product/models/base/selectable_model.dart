class SelectableModel<T> {
  bool isSelected;
  T? model;
  SelectableModel({
    this.isSelected = false,
    this.model,
  });
}
