import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaSelecaoIdioma(),
    );
  }
}

class TelaSelecaoIdioma extends StatelessWidget {
  const TelaSelecaoIdioma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const VideoBackground(
            videoPath: 'assets/videos/gas_in_oil.mp4',
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SELECIONE UM IDIOMA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 96.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: PaisButtonWidget(
                        caminhoImagem: 'assets/images/brasil.png',
                        idioma: 'Português',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: PaisButtonWidget(
                        caminhoImagem: 'assets/images/estados-unidos.png',
                        idioma: 'Inglês',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: PaisButtonWidget(
                        caminhoImagem: 'assets/images/espanha.png',
                        idioma: 'Espanhol',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaisButtonWidget extends StatelessWidget {
  final String caminhoImagem;
  final String idioma;

  const PaisButtonWidget({
    super.key,
    required this.caminhoImagem,
    required this.idioma,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Idioma selecionado: $idioma');
      },
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(caminhoImagem, height: 50.0, width: 50.0),
          const SizedBox(height: 8.0),
          Text(
            idioma,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoBackground extends StatefulWidget {
  final String videoPath;
  const VideoBackground({super.key, required this.videoPath});

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(color: Colors.black);
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              const Color(0xC0000000),
              BlendMode.darken,
            ),
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}