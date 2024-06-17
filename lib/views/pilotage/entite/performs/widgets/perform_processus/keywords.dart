import 'package:flutter/material.dart';
import 'package:perf_rse/utils/i18n.dart';

class KeywordsGrid extends StatelessWidget {
  const KeywordsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 5, // nombre de processus a determiner
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          hoverColor: Colors.transparent,
          onTap: (){},
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xffEBF6FF),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(tr.keyNumber,
                      maxLines: 2,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff8EA3B7),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 7,
                          decoration: BoxDecoration(
                              color: const Color(0xff369FFF),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        const Text(
                          "20 %",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff006ED3),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}
