import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cube/flutter_cube.dart';

import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _earth;
  late Object _stars;
  late AnimationController _controller;

  Object? _orbitPoint;

  void generateOrbitPoint() async {
    // Criar o objeto do ponto
    _orbitPoint = Object(name: 'orbitPoint', scale: Vector3.all(0.05));
    generateSphereObject(_orbitPoint!, 'surface', 1.0, true, 'assets/images/metal.jpg');

    // Define a posição do ponto em relação ao planeta
    _orbitPoint!.position.x = 4; // Ajuste a posição conforme necessário
    _orbitPoint!.position.y = 0; // Ajuste a posição conforme necessário
    _orbitPoint!.position.z = 0; // Ajuste a posição conforme necessário

    // Adicionar o ponto à cena
    _scene.world.add(_orbitPoint!);

    // Atualizar a textura
    _scene.updateTexture();
  }

  void generateSphereObject(Object parent, String name, double radius, bool backfaceCulling, String texturePath) async {
    final Mesh mesh = await generateSphereMesh(radius: radius, texturePath: texturePath);
    parent.add(Object(name: name, mesh: mesh, backfaceCulling: backfaceCulling));
    _scene.updateTexture();
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _scene.camera.position.z = 34;

    _earth = Object(name: 'earth', scale: Vector3(10.0, 10.0, 10.0));
    generateSphereObject(_earth!, 'surface', 0.485, true, 'assets/images/earth/4096_night_lights.jpg');
    generateSphereObject(_earth!, 'clouds', 0.5, true, 'assets/images/earth/4096_clouds.png');
    _scene.world.add(_earth!);

    _stars = Object(name: 'stars', scale: Vector3(2000.0, 2000.0, 2000.0));
    generateSphereObject(_stars, 'surface', 0.5, false, 'assets/images/stars/2k_stars.jpg');
    _scene.world.add(_stars);

    generateOrbitPoint();
    if (_orbitPoint != null) {
      _orbitPoint!.rotation.y = 0;
      _orbitPoint!.updateTransform();
      _earth!.add(_orbitPoint!);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(minutes: 1), vsync: this)
      ..addListener(() {
        if (_earth != null) {
          _earth!.rotation.y = _controller.value * 360;
          _earth!.updateTransform();
          _scene.update();
        }
      })
      ..addListener(() {
      if (_earth != null && _orbitPoint != null) {
          // Calcula a posição do ponto ao redor da Terra usando trigonometria
          double angle = _controller.value * 2 * math.pi; // Ângulo de rotação em radianos
          double radius = 7.0; // Raio da órbita do ponto em torno da Terra
          double x = radius * math.cos(angle); // Coordenada x
          double z = radius * math.sin(angle); // Coordenada z

          // Atualiza a posição do ponto em relação à Terra
          _orbitPoint!.position.x = x;
          _orbitPoint!.position.z = z;
          _orbitPoint!.updateTransform();

          _scene.update();
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Mesh> generateSphereMesh(
      {num radius = 0.5,
      int latSegments = 32,
      int lonSegments = 64,
      required String texturePath}) async {
    int count = (latSegments + 1) * (lonSegments + 1);
    List<Vector3> vertices = List<Vector3>.filled(count, Vector3.zero());
    List<Offset> texcoords = List<Offset>.filled(count, Offset.zero);
    List<Polygon> indices =
        List<Polygon>.filled(latSegments * lonSegments * 2, Polygon(0, 0, 0));

    int i = 0;
    for (int y = 0; y <= latSegments; ++y) {
      final double v = y / latSegments;
      final double sv = math.sin(v * math.pi);
      final double cv = math.cos(v * math.pi);
      for (int x = 0; x <= lonSegments; ++x) {
        final double u = x / lonSegments;
        vertices[i] = Vector3(radius * math.cos(u * math.pi * 2.0) * sv,
            radius * cv, radius * math.sin(u * math.pi * 2.0) * sv);
        texcoords[i] = Offset(1.0 - u, 1.0 - v);
        i++;
      }
    }

    i = 0;
    for (int y = 0; y < latSegments; ++y) {
      final int base1 = (lonSegments + 1) * y;
      final int base2 = (lonSegments + 1) * (y + 1);
      for (int x = 0; x < lonSegments; ++x) {
        indices[i++] = Polygon(base1 + x, base1 + x + 1, base2 + x);
        indices[i++] = Polygon(base1 + x + 1, base2 + x + 1, base2 + x);
      }
    }

    ui.Image texture = await loadImageFromAsset(texturePath);
    final Mesh mesh = Mesh(
        vertices: vertices,
        texcoords: texcoords,
        indices: indices,
        texture: texture,
        texturePath: texturePath);
    return mesh;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Cube(onSceneCreated: _onSceneCreated),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: const Color.fromRGBO(32, 30, 57, .7),
                  hintText: 'Search a object',
                  hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, .6)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Transform.scale(
                    scale: .5,
                    child: SvgPicture.asset(
                      'assets/svg/compass.svg',
                      colorFilter: const ColorFilter.mode(Color.fromRGBO(255, 255, 255, .7), BlendMode.srcIn),
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white
                ),
                cursorColor: Colors.white,
            ),
          )
        ]
      ),
    );
  }
}
