import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perf_rse/helper/helper_methods.dart';
import 'package:perf_rse/views/gestion/data/data_content.dart';

class ContentGrid extends StatefulWidget {
  const ContentGrid({Key? key}) : super(key: key);

  @override
  _ContentGridState createState() => _ContentGridState();
}

class _ContentGridState extends State<ContentGrid> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: contentData.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 16 / 7,
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 30,
      ),
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              _hoveredIndex = index;
            });
          },
          onExit: (_) {
            setState(() {
              _hoveredIndex = -1;
            });
          },
          child: InkWell(
            onTap: () {
              _showMyDialog(
                context,
                contentData[index].pathImage,
                contentData[index].text,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()
                ..scale(_hoveredIndex == index ? 1.1 : 1.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(contentData[index].backImage),
                  fit: BoxFit.fill,
                ),
              ),
child: Padding(
  padding: const EdgeInsets.all(16),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            contentData[index].text,
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ],
  ),
),

            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String imagePath, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFFC000),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: ImageWidget(imagePath: imagePath),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Fermer",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      width: 700,
      imagePath,
      fit: BoxFit.fill,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? pixel,
        bool isShow,
      ) {
        if (pixel == null) {
          return SizedBox(
            width: 700,
            height: 500,
            child: Column(
              children: [
                loadingPageWidget(),
              ],
            ),
          );
        }
        return child;
      },
    );
  }
}


