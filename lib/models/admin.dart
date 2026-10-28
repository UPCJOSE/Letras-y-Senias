class AdminDashboardStats {
  const AdminDashboardStats({
    required this.people,
    required this.translations,
    required this.draftSigns,
    required this.untranslatedWords,
  });

  final int people;
  final int translations;
  final int draftSigns;
  final int untranslatedWords;
}
