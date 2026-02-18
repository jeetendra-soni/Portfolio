enum AuthStatus { idle, loading, success, error }

enum SkillLevel { beginner, intermediate, expert }

enum SkillCategory { devTools, backendApis, architecture , stateManagement, language, frameWork, systemWork}


extension SkillCategoryX on SkillCategory {
  String get value {
    return name; // Dart 2.15+
  }

  String get label {
    switch (this) {
      case SkillCategory.devTools:
        return "Dev Tools";
      case SkillCategory.backendApis:
        return "Backend & APIs";
      case SkillCategory.architecture:
        return "Architecture";
      case SkillCategory.stateManagement:
        return "State Management";
      case SkillCategory.language:
        return "Language";
      case SkillCategory.frameWork:
        return "Framework";
      case SkillCategory.systemWork:
        return "System Work";
    }
  }
}

enum ProjectStatus {
  live,
  inProgress,
  completed,
}

