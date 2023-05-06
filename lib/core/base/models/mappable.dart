abstract class IMappable implements IToMappable, IFromMappable {}

abstract class IToMappable {
  Map<String, dynamic> toMap();
}

abstract class IFromMappable {
  IFromMappable fromMap(Map<String, dynamic> map);
}
