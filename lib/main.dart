import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:ui';
import 'dart:io';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/detail': (context) =>
              const Detail(image: '', width: '', height: ''),
        });
  }
}

class _PhotoItem {
  final String image;
  final String width;
  final String height;
  _PhotoItem(this.image, this.width, this.height);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_PhotoItem> _photos = [];
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  void _addFromPhoto() async {
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File file = File(image.path);
      var decodedImage = await decodeImageFromList(file.readAsBytesSync());
      setState(() {
        _photos.add(_PhotoItem(image.path, decodedImage.width.toString(),
            decodedImage.height.toString()));
      });
    } else {
      return;
    }
  }

  void _useCamera() async {
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File file = File(image.path);
      var decodedImage = await decodeImageFromList(file.readAsBytesSync());
      setState(() {
        _photos.add(_PhotoItem(image.path, decodedImage.width.toString(),
            decodedImage.height.toString()));
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.02),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.02,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Album',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.04,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
          mainAxisSpacing: MediaQuery.of(context).size.width * 0.01,
          crossAxisCount: 3,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.02,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detail(
                      image: _photos[index].image,
                      width: _photos[index].width,
                      height: _photos[index].height),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.03),
              child: Image.file(
                File(_photos[index].image),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.015,
              ),
              Expanded(
                child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey[350],
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.035),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _addFromPhoto();
                  },
                  icon: Icon(
                    Icons.photo_library_outlined,
                    size: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.blue,
                  ),
                  label: Text(
                    'Add from photo',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.015,
              ),
              Expanded(
                child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blue,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.035),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _useCamera();
                  },
                  icon: Icon(
                    Icons.photo_camera_outlined,
                    size: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Use camera',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.015,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  final String image;
  final String width;
  final String height;
  const Detail(
      {Key? key,
      required this.image,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blue,
        leading: TextButton.icon(
          label: const Text(''),
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_sharp,
                size: MediaQuery.of(context).size.width * 0.07,
              ),
              // SizedBox(width: MediaQuery.of(context).size.width * 0.0001),
              Text(
                'Album',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ],
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
            child: Center(
              child: Column(children: [
                Text(
                  'Image width: $width px',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  'Image height: $height px',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
