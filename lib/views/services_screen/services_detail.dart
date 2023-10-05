import 'package:wedeaseseller/const/const.dart';
import 'package:wedeaseseller/views/widgets/normal_text.dart';

class ServiceDetails extends StatelessWidget {
  final dynamic data;
  const ServiceDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back button
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: black,
          ),
        ),
        title: boldText(text: "${data['s_name']}", size: 16.0, color: black),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Swiper images
              VxSwiper.builder(
                itemCount: data['s_imgs'].length,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 3),
                aspectRatio: 16 / 9,
                itemBuilder: (context, index) {
                  return Image.network(
                    data['s_imgs'][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
              // Service details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boldText(text: 'Name:', size: 16.0, color: black),
                        8.widthBox,
                        normalText(
                            text: "${data['s_name']}",
                            size: 16.0,
                            color: black),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        boldText(text: 'Location:', size: 16.0, color: black),
                        8.widthBox,
                        normalText(
                            text: "${data['s_location']}",
                            size: 16.0,
                            color: black),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        boldText(text: 'Ratings:', size: 16.0, color: black),
                        8.widthBox,
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 224, 212, 10)),
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 234, 212, 10)),
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 234, 212, 10)),
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 234, 212, 10)),
                            const Icon(Icons.star_border,
                                color: Color.fromARGB(255, 232, 212, 10)),
                            const SizedBox(width: 4),
                            normalText(
                                text: "${data['s_rating']}",
                                size: 16.0,
                                color: black),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        boldText(text: 'Rate:', size: 16.0, color: black),
                        8.widthBox,
                        normalText(
                            text: "${data['s_price']}",
                            size: 16.0,
                            color: black),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle),
                        child: Center(
                          child: boldText(
                              text: 'Features:', size: 16.0, color: black),
                        )),
                    const SizedBox(height: 8),
                    normalText(
                        text: "${data['s_features']}",
                        size: 16.0,
                        color: black),
                    // normalText(
                    //     text: 'Catering Available', size: 16.0, color: black),
                    // normalText(text: 'Inside Mandap', size: 16.0, color: black),
                    // normalText(
                    //     text: 'Music Available in needed',
                    //     size: 16.0,
                    //     color: black),
                    // normalText(
                    //     text: 'Parking for 100 cars', size: 16.0, color: black),
                    const SizedBox(height: 16),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle),
                        child: Center(
                          child: boldText(
                              text: 'Description:', size: 16.0, color: black),
                        )),
                    const SizedBox(height: 8),
                    normalText(
                      text: "${data['s_description']}",
                      size: 16.0,
                      color: black,
                    ),

                    // const Text(
                    //  "${data['s_description']}",
                    //   textAlign:
                    //       TextAlign.justify, // Set text alignment to justify
                    //   style: TextStyle(
                    //     fontSize: 16.0,
                    //     color: black,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
