import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/devices/interfaces/pages/organizations/organizations_cubit.dart';
import 'package:mobile/devices/interfaces/widgets/create_organization_form.dart';
import 'package:mobile/shared/interfaces/widgets/clair_name.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ClairName(height: 18),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF2A2A2A),
              child: Icon(Icons.person, size: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'org_add',
            backgroundColor: Colors.white.withValues(alpha: 0.12),
            foregroundColor: Colors.white,
            onPressed: () => _openCreateOrganizationSheet(context),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'org_more',
            mini: true,
            backgroundColor: Colors.white.withValues(alpha: 0.10),
            foregroundColor: Colors.white70,
            onPressed: () {},
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: BlocBuilder<OrganizationsCubit, OrganizationsState>(
        builder: (context, state) {
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

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Organizations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<OrganizationsCubit>().loadOrganizations(),
                    child: ListView.separated(
                      itemCount: state.organizations.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final org = state.organizations[index];
                        return _OrganizationCard(
                          name: org.name,
                          deviceCountLabel: '0 DEVICES',
                          onTap: () {},
                        );
                      },
                    ),
                  ),
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
  final String name;
  final String deviceCountLabel;
  final VoidCallback onTap;

  const _OrganizationCard({
    required this.name,
    required this.deviceCountLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  deviceCountLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
