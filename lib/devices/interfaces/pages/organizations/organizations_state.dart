part of 'organizations_cubit.dart';

class OrganizationsState {
  final bool isLoading;
  final String? errorMessage;
  final List<OrganizationResponseResource> organizations;

  const OrganizationsState({
    this.isLoading = false,
    this.errorMessage,
    this.organizations = const [],
  });

  OrganizationsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OrganizationResponseResource>? organizations,
  }) {
    return OrganizationsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      organizations: organizations ?? this.organizations,
    );
  }
}
