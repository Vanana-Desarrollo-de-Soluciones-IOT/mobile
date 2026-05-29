import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/devices/interfaces/pages/organizations/organizations_cubit.dart';
import 'package:mobile/devices/interfaces/widgets/create_organization_form.dart';
import 'package:mobile/devices/interfaces/widgets/edit_organization_name_form.dart';

class OrganizationsScreen extends StatefulWidget {
  const OrganizationsScreen({super.key});

  @override
  State<OrganizationsScreen> createState() => _OrganizationsScreenState();
}

class _OrganizationsScreenState extends State<OrganizationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrganizationsCubit>().loadOrganizations();
  }

  Future<void> _openCreateOrganizationSheet(BuildContext context) async {
    final cubit = context.read<OrganizationsCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: BlocBuilder<OrganizationsCubit, OrganizationsState>(
              builder: (context, state) {
                return CreateOrganizationForm(
                  isLoading: state.isLoading,
                  onSubmit: (name) async {
                    await cubit.createOrganization(name);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _openEditOrganizationSheet({
    required BuildContext context,
    required String organizationId,
    required String currentName,
  }) async {
    final cubit = context.read<OrganizationsCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: BlocBuilder<OrganizationsCubit, OrganizationsState>(
              builder: (context, state) {
                return EditOrganizationNameForm(
                  isLoading: state.isLoading,
                  initialName: currentName,
                  onSubmit: (name) async {
                    await cubit.updateOrganizationName(
                      organizationId: organizationId,
                      name: name,
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteOrganization({
    required BuildContext context,
    required String organizationId,
    required String organizationName,
  }) async {
    final cubit = context.read<OrganizationsCubit>();
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete organization?'),
          content: Text('This will delete "$organizationName".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await cubit.deleteOrganization(organizationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<OrganizationsCubit, OrganizationsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organizations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.isLoading && state.organizations.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.errorMessage != null && state.organizations.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (state.organizations.isEmpty) {
                        return const Center(
                          child: Text(
                            'No organizations yet',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => context.read<OrganizationsCubit>().loadOrganizations(),
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 4),
                          itemCount: state.organizations.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final org = state.organizations[index];
                            return _OrganizationCard(
                              id: org.id,
                              name: org.name,
                              onEdit: () => _openEditOrganizationSheet(
                                context: context,
                                organizationId: org.id,
                                currentName: org.name,
                              ),
                              onDelete: () => _confirmDeleteOrganization(
                                context: context,
                                organizationId: org.id,
                                organizationName: org.name,
                              ),
                              onTap: () => context.go(
                                '/spaces/${org.id}',
                                extra: org.name,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                _AddOrganizationButton(
                  onPressed: () => _openCreateOrganizationSheet(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrganizationCard extends StatelessWidget {
  final String id;
  final String name;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _OrganizationCard({
    required this.id,
    required this.name,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Row(
            children: [
               Expanded(
                 child: Text(
                   name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                 ),
               ),
              IconButton(
                tooltip: 'Edit',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.white70),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddOrganizationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddOrganizationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.domain_outlined, size: 18),
        label: const Text('Add Organization'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
