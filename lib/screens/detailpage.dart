import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:clipboard/clipboard.dart';
import 'package:festival_post_app/utils/global.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey imageKey = GlobalKey();
  Color backgroundColor = Colors.white;
  double descriptionFontSize = 16;
  int fontStyleIndex = 0;
  Color fontColor = Colors.white;

  final List<TextStyle> fontStyles = [
    const TextStyle(fontFamily: 'Roboto', fontSize: 16),
    const TextStyle(fontFamily: 'Arial', fontSize: 16),
    const TextStyle(fontFamily: 'Courier', fontSize: 16),
    const TextStyle(fontFamily: 'Times New Roman', fontSize: 16),
    const TextStyle(fontFamily: 'Sans Serif', fontSize: 16),
    const TextStyle(fontFamily: 'Comic Sans', fontSize: 16),
    const TextStyle(fontFamily: 'Georgia', fontSize: 16),
    const TextStyle(fontFamily: 'Verdana', fontSize: 16),
    const TextStyle(fontFamily: 'Impact', fontSize: 16),
  ];

  final List<Color> fontColors = [
    Colors.white,
    Colors.black,
    Colors.pink,
    Colors.orange,
    Colors.cyan,
    Colors.brown,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  int fontColorIndex = 0;

  Future<void> _saveImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
    imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    var image = await renderRepaintBoundary.toImage(pixelRatio: 5);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List fetchImage = byteData!.buffer.asUint8List();

    Directory directory = await getExternalStorageDirectory() ?? await getTemporaryDirectory();
    String path = '${directory.path}/saved_festival_image.png';
    File file = File(path);

    await file.writeAsBytes(fetchImage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image saved to $path')),
    );
  }

  Future<void> shareImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
    imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    var image = await renderRepaintBoundary.toImage(pixelRatio: 5);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List fetchImage = byteData!.buffer.asUint8List();

    Directory directory = await getApplicationCacheDirectory();

    String path = directory.path;

    File file = File('$path.png');

    file.writeAsBytes(fetchImage);

    ShareExtend.share(file.path, "Image");
  }

  void _showColorPicker() {
    showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Background Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: backgroundColor,
              onColorChanged: (color) {
                setState(() {
                  backgroundColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(backgroundColor);
              },
            ),
          ],
        );
      },
    ).then((selectedColor) {
      if (selectedColor != null) {
        setState(() {
          backgroundColor = selectedColor;
        });
      }
    });
  }

  void _increaseFontSize() {
    setState(() {
      descriptionFontSize += 2;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      descriptionFontSize = descriptionFontSize > 8 ? descriptionFontSize - 2 : 8;
    });
  }

  void _cycleFontStyle() {
    setState(() {
      fontStyleIndex = (fontStyleIndex + 1) % fontStyles.length;
    });
  }

  void _cycleFontColor() {
    setState(() {
      fontColorIndex = (fontColorIndex + 1) % fontColors.length;
      fontColor = fontColors[fontColorIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF339F74),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _saveImage,
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: shareImage,
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () async {
              await FlutterClipboard.copy(
                "${Festivals.festivals[data]['name']} ${Festivals.festivals[data]['description']}",
              ).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your Text Copied Successfully"),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
        title: Text(
          "${Festivals.festivals[data]['name']}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          RepaintBoundary(
            key: imageKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("${Festivals.festivals[data]['image']}"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      backgroundColor.withOpacity(0.7),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${Festivals.festivals[data]['name']}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "${Festivals.festivals[data]['date']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${Festivals.festivals[data]['description']}",
                        style: fontStyles[fontStyleIndex].copyWith(
                          fontSize: descriptionFontSize,
                          color: fontColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Colors.white.withOpacity(0.2),
            ),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(
                  thickness: 6,
                  endIndent: MediaQuery.of(context).size.width / 6,
                  indent: MediaQuery.of(context).size.width / 6,
                  color: Colors.black45,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _showColorPicker,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),

                        ),
                        child: const Text("Change Background Color"),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _increaseFontSize,
                            icon: const Icon(Icons.add_circle, size: 30),
                            tooltip: 'Increase Font Size',
                          ),
                          Text(
                            "$descriptionFontSize",
                            style: const TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            onPressed: _decreaseFontSize,
                            icon: const Icon(Icons.remove_circle, size: 30),
                            tooltip: 'Decrease Font Size',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _cycleFontStyle,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: fontStyles[fontStyleIndex].color,

                            ),
                            child: const Text("Change Font Style"),
                          ),
                          const SizedBox(width: 12),

                          ElevatedButton(
                            onPressed: _cycleFontColor,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: fontColor,

                            ),
                            child: const Text("Change Font Color"),
                          ),
                        ],
                      ),
                    ],
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
