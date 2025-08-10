import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_management_system/Provider/module_provider.dart';
import 'package:school_management_system/Provider/ue_provider.dart';
import 'package:school_management_system/Widgets/drawer.dart';
import 'package:school_management_system/Widgets/module_card.dart';
import 'package:school_management_system/Widgets/my_appbar.dart';

class ListeDesModules extends ConsumerWidget {
  const ListeDesModules({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(getAllModulesProvider);
    final uesAsync =
        ref.watch(getAllUesProvider); // Nouveau provider pour les UEs

    return Scaffold(
      body: Row(
        children: [
           MyDrawer(),
          Expanded(
            child: Column(
              children: [
                MyAppbar(
                  title: "Liste de tous les Modules",
                  onTap: () {},
                  boutonName: "Ajouter un Module",
                ),
                Expanded(
                  child: modulesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                        Center(child: Text("Erreur : $error")),
                    data: (modules) {
                      return uesAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text("Erreur UEs: $error")),
                        data: (ues) {
                          if (modules.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.sentiment_dissatisfied, size: 50),
                                  Text("Aucun module trouvé"),
                                ],
                              ),
                            );
                          }

                          // Création d'une map pour une recherche rapide des UEs
                          final ueMap = {for (var ue in ues) ue.id: ue};

                          return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 320,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 200,
                              ),
                              itemCount: modules.length,
                              itemBuilder: (context, index) {
                                final module = modules[index];

                                // Solution la plus robuste
                                final ueId = module.ue?.id;
                                final ue = ueId != null ? ueMap[ueId] : null;

                                return ModuleCard(
                                  nomModule: module.nomModule,
                                  volumeHoraire: module.volumeHoraire,
                                  creditModule: module.creditModule,
                                  nomUE: ue?.nomUE ?? "Non spécifiée",
                                );
                              });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
