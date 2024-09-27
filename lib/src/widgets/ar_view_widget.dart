// lib/widgets/ar_view_widget.dart

import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';

class ARViewWidget extends StatefulWidget {
  const ARViewWidget({super.key});

  @override
  _ARViewWidgetState createState() => _ARViewWidgetState();
}

class _ARViewWidgetState extends State<ARViewWidget> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  void dispose() {
    arSessionManager.dispose();    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ARView(
      onARViewCreated: onARViewCreated,
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    if (!mounted) return;
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      customPlaneTexturePath: 'assets/images/triangle.png',
      showWorldOrigin: true,
      handleTaps: false,
    );

    arObjectManager.onInitialize();
    // You can now add objects to the scene
    // Example: add an AR object when the scene is ready
    addARObject();
  }

  Future<void> addARObject() async {
    if (!mounted) return;
    // Load a 3D model from the assets or network
    final node = ARNode(
      type: NodeType.localGLTF2,
      uri: 'assets/models/site_marker.gltf',
      scale: Vector3(0.1, 0.1, 0.1),
      position: Vector3(0.0, 0.0, -1.0),
    );

    bool? didAddNode = await arObjectManager.addNode(node);
    if (didAddNode == true) {
      print('AR object added successfully');
    } else {
      print('Failed to add AR object');
    }
  }
}
