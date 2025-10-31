import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/map_providers.dart';
import '../widgets/map_view.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final _mapViewKey = GlobalKey<MapViewState>();

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(featuresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Localiza ai, bb 🌍'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
            onPressed: () => ref.refresh(featuresProvider),
          ),
        ],
      ),
      body: async.when(
        data: (features) {
          // centro simples: usa o primeiro ponto se existir
          final centers = features.map((f) {
            if (f.coordinates.isEmpty) return const LatLng(-23.55, -46.63);
            final c = f.coordinates.first; // [lon, lat]
            return LatLng(c[1], c[0]);
          }).toList();

          return Stack(
            children: [
              MapView(
                key: _mapViewKey,
                initialMarkers: centers,
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: FloatingActionButton.small(
                  heroTag: 'loc',
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location, color: Colors.blue),
                  onPressed: () {
                    _mapViewKey.currentState
                        ?.locateUser(showFeedback: true, moveCamera: true);
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'layers',
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.layers_outlined,
                          color: Colors.black87),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Alternar camadas — em breve')),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton.small(
                      heroTag: 'settings',
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.settings_outlined,
                          color: Colors.black87),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}
