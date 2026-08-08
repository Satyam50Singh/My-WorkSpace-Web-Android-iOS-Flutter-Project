class Company {
  final int companyId;
  final String companyName;
  final String clientUrl;
  final List<int> moduleIds;
  final String companyLogo;

  const Company({
    required this.companyId,
    required this.companyName,
    required this.clientUrl,
    required this.moduleIds,
    required this.companyLogo,
  });
}
