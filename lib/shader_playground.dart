import 'package:flutter/material.dart';

import 'resources/shaders.dart';
import 'widgets/shader_visualizer.dart';

class ShaderPlayground extends StatelessWidget {
  const ShaderPlayground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shader Playground',
      home: ShaderVisualizer(
        shader: Shaders.rainbow,
        animated: true,
      ),
    );
  }
}
