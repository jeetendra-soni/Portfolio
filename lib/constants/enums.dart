enum AuthStatus { idle, loading, success, error }

enum SkillLevel { beginner, intermediate, expert }

enum SkillCategoryType { devTools, backendApis, architecture , stateManagement, language, frameWork, systemWork}


extension SkillCategoryX on SkillCategoryType {
  String get value {
    return name; // Dart 2.15+
  }

  String get label {
    switch (this) {
      case SkillCategoryType.devTools:
        return "Dev Tools";
      case SkillCategoryType.backendApis:
        return "Backend & APIs";
      case SkillCategoryType.architecture:
        return "Architecture";
      case SkillCategoryType.stateManagement:
        return "State Management";
      case SkillCategoryType.language:
        return "Language";
      case SkillCategoryType.frameWork:
        return "Framework";
      case SkillCategoryType.systemWork:
        return "System Work";
    }
  }
}

enum ProjectStatus {
  live,
  inProgress,
  completed,
}