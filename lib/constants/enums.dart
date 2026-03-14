enum AuthStatus { idle, loading, success, error }

enum SkillLevel { beginner, intermediate, expert }

enum SkillCategoryType { devTools, deployment, backendApis, architecture , stateManagement, language,aiDevelopment, frameWork, database, systemWork, others}


extension SkillCategoryX on SkillCategoryType {
  String get value {
    return name; // Dart 2.15+
  }

  String get label {
    switch (this) {
      case SkillCategoryType.devTools:
        return "Dev Tools";
      case SkillCategoryType.deployment:
        return "Cloud & Deployment";
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
      case SkillCategoryType.database:
        return "Database & Storage";
      case SkillCategoryType.systemWork:
        return "System Work";
      case SkillCategoryType.aiDevelopment:
        return "AI-Assisted Development";
      default:
        return "Others";
    }
  }
}

enum ProjectStatus {
  live,
  inProgress,
  completed,
}