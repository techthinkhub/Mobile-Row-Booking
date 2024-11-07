import 'dart:io';

import 'package:customer_bengkelly/app/componen/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../authorization/componen/fade_animationtest.dart';
import '../componen/list_kendataan.dart';
import '../componen/select_maps_emergency.dart';
import '../controllers/emergencybooking_controller.dart';

class EmergencyBookingView extends StatefulWidget {
  @override
  EmergencyBookingViewState createState() => EmergencyBookingViewState();
}

class EmergencyBookingViewState extends State<EmergencyBookingView> {
  EmergencyBookingViewController controller = Get.put(EmergencyBookingViewController());
  Position? _currentPosition;
  String _currentAddress = 'Mengambil lokasi...';
  bool isManual = false;


  @override
  void initState() {
    super.initState();
    _checkPermissions();
    if (!isManual) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current position: $_currentPosition');
      await _getAddressFromLatLng(); // Pastikan untuk menunggu hasil dari metode ini
      setState(() {
        controller.locationController.text = '${_currentPosition!.latitude}, ${_currentPosition!.longitude}';
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = "${place.locality}, ${place.subAdministrativeArea}";
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    print('Permission status: $status');
    if (status.isGranted) {
      print('Permission already granted');
      await _getCurrentLocation();
    } else {
      var requestedStatus = await Permission.location.request();
      print('Requested permission status: $requestedStatus');
      if (requestedStatus.isGranted) {
        print('Permission granted');
        await _getCurrentLocation();
      } else {
        print('Permission denied');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission denied'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> tipeList = ["AT", "MT"];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Obx(() => SizedBox(
                height: 50, // <-- Your height
                child: ElevatedButton(
                  onPressed: (controller.isFormValidEmergency() && !controller.isLoading.value) ||
                      (controller.isFormValidEmergencypic() && !controller.isLoading.value) ||
                      (controller.isFormValidEmergencyDepartemen() && !controller.isLoading.value)
                      ? () {
                    controller.EmergencyServiceVale();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (controller.isFormValidEmergency() || controller.isFormValidEmergencypic() || controller.isFormValidEmergencyDepartemen())
                        ? MyColors.appPrimaryColor
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4.0,
                  ),
                  child: controller.isLoading.value
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Loading...',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Booking Sekarang',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text('Emergency Service', style: GoogleFonts.nunito(color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold),),
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInAnimation(
                          delay: 1.8,
                          child: Text('Kendaraan', style: GoogleFonts.nunito(),),
                        ),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: MyColors.bgformborder),
                                borderRadius: BorderRadius.circular(10)),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      heightFactor: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 45,),
                                          Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(16.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child:  Icon(Icons.close_rounded),
                                              )
                                          ),
                                          Container(
                                            height: 60,
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Pilih Kendaraan',
                                              style: GoogleFonts.nunito(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.appPrimaryColor,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListKendaraanWidget(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Obx(() => InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.selectedTransmisiPIC.value == null &&
                                            controller.selectedTransmisi.value == null &&
                                            controller.selectedTransmisiDepartemen.value == null
                                            ? 'Pilih Kendaraan'
                                            : controller.selectedTransmisiPIC.value != null
                                            ? '${controller.selectedTransmisiPIC.value!.namaMerk} - ${controller.selectedTransmisiPIC.value!.namaTipe ?? ''}\nNo Pol : ${controller.selectedTransmisiPIC.value!.noPolisi ?? ''}\nNomor Lambung : ${controller.selectedTransmisiPIC.value!.vinNumber ?? ''}'
                                            : controller.selectedTransmisi.value != null
                                            ? '${controller.selectedTransmisi.value!.merks?.namaMerk} - ${controller.selectedTransmisi.value!.tipes?.map((e) => e.namaTipe).join(", ")}\nNo Pol : ${controller.selectedTransmisi.value!.noPolisi ?? ''}\nNomor Lambung : ${controller.selectedTransmisi.value!.vinnumber ?? ''} '
                                            : '${controller.selectedTransmisiDepartemen.value!.namaMerk} - ${controller.selectedTransmisiDepartemen.value!.namaTipe ?? ''}\nNo Pol  - ${controller.selectedTransmisiDepartemen.value!.noPolisi ?? ''}\nNomor Lambung : ${controller.selectedTransmisiDepartemen.value!.vinNumber ?? ''}',
                                        style: GoogleFonts.nunito(
                                          color: controller.selectedTransmisiPIC.value == null &&
                                              controller.selectedTransmisi.value == null &&
                                              controller.selectedTransmisiDepartemen.value == null
                                              ? Colors.grey
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Text('Photo / Video kerusakan kendaraan anda', style: GoogleFonts.nunito(),),
                        ),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Obx(() {
                            // Konversi XFile ke File
                            final files = [
                              ...controller.imageFiles.map((xFile) => File(xFile.path)),
                              ...controller.videoFiles.map((xFile) => File(xFile.path))
                            ];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.showBottomSheet(context),
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: MyColors.bgformborder),
                                    ),
                                    child: files.isEmpty
                                        ? const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_circle_outline_rounded, color: Colors.grey),
                                          SizedBox(width: 10),
                                          Text('Tambah Foto / Video'),
                                        ],
                                      ),
                                    )
                                        : files.length == 1
                                        ? _buildSingleFileView(files[0])
                                        : _buildGridView(files),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 10,),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Text('Lokasi', style: GoogleFonts.nunito(),),
                        ),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.bgformborder),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:  GestureDetector(
                              onTap: () async {
                                final result = await Get.to(() => SelectBookingEmergency());
                                if (result != null) {
                                  controller.selectedLocation.value = result['name'];
                                }
                              },
                              child: Obx(() => InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.selectedLocation.value ?? 'Pilih Lokasi',
                                        style: GoogleFonts.nunito(
                                          color: controller.selectedLocation.value == null ? Colors.grey : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.map_sharp, color: Colors.grey),
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Lokasi terdeteksi :', style: GoogleFonts.nunito()),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isManual ? '' : _currentAddress,
                                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isManual) {
                                          String combinedLocation = '${controller.alamatmanualController.text}';
                                          controller.locationController.text = combinedLocation;
                                          controller.alamatmanualController.clear();
                                        } else {
                                          _getCurrentLocation(); // Panggil metode untuk mendapatkan lokasi terbaru
                                        }
                                        isManual = !isManual;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.appPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          isManual ? 'Auto' : 'Manual',
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (isManual) ...[
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: MyColors.bgformborder),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                      controller: controller.alamatmanualController,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(13),
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.nunito(color: Colors.grey),
                                        hintText: 'Masukan alamat lokasi anda berada',
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: MyColors.bgformborder),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                      enabled: false,
                                      controller: controller.locationController,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(13),
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.nunito(color: Colors.grey),
                                        hintText: 'Lokasi saat ini',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Penting !! ', // Teks penting
                                      style: GoogleFonts.nunito(color: Colors.red, fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: 'Bila lokasi tidak terdeteksi anda dapat input alamat secara manual', // Teks biasa
                                      style: GoogleFonts.nunito(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10,),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Text('Keluhan', style: GoogleFonts.nunito(),),
                        ),
                        FadeInAnimation(
                          delay: 1.8,
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.bgformborder), // Change to your primary color
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 200, // <-- TextField expands to this height.
                              child: TextField(
                                controller: TextEditingController(text: controller.Keluhan.value),
                                onChanged: (value) {
                                  controller.Keluhan.value = value;
                                },
                                maxLines: null, // Set this
                                expands: true, // and this
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(18),
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.nunito(color: Colors.grey),
                                    hintText: 'Keluhan Kendaraan anda'
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSingleFileView(File file) {
    final isVideo = file.path.endsWith('.mp4');
    return Center(
      child: isVideo
          ? (controller.videoController.value != null &&
          controller.videoController.value!.value.isInitialized
          ? VideoPlayer(controller.videoController.value!)
          : Center(child: CircularProgressIndicator()))
          : Image.file(file),
    );
  }

  Widget _buildGridView(List<File> files) {
    return GridView.builder(
      padding: EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final isVideo = file.path.endsWith('.mp4');

        return Stack(
          children: [
            isVideo
                ? (controller.videoController.value != null &&
                controller.videoController.value!.value.isInitialized
                ? VideoPlayer(controller.videoController.value!)
                : Center(child: CircularProgressIndicator()))
                : Image.file(file),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Panggil metode deleteFile dengan file yang benar dan tipe isVideo
                  controller.deleteFile(file as XFile, isVideo);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class upload extends StatefulWidget {
  const upload({super.key});

  @override
  State<upload> createState() => _uploadState();
}

class _uploadState extends State<upload> {
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  VideoPlayerController? _videoController;

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.camera); // Ambil gambar dari kamera
    if (file != null) {
      setState(() {
        _file = file;
        _videoController?.dispose(); // Hapus VideoPlayerController jika mengganti video dengan gambar
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.camera); // Ambil video dari kamera
    if (file != null) {
      setState(() {
        _file = file;
        _videoController = VideoPlayerController.file(File(file.path))
          ..initialize().then((_) {
            setState(() {});
            _videoController?.play();
          });
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickMedia();
    if (file != null) {
      setState(() {
        _file = file;
        if (file.path.endsWith('.mp4')) {
          _videoController = VideoPlayerController.file(File(file.path))
            ..initialize().then((_) {
              setState(() {});
              _videoController?.play();
            });
        } else {
          _videoController?.dispose();
        }
      });
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih Foto atau Video dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(); // Ambil gambar dari kamera
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Ambil Video dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(); // Ambil video dari kamera
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteFile() {
    if (_file != null) {
      setState(() {
        // Hapus VideoPlayerController jika ada
        if (_file!.path.endsWith('.mp4')) {
          _videoController?.dispose();
        }

        // Hapus file
        final file = File(_file!.path);
        if (file.existsSync()) {
          file.deleteSync();
        }

        // Reset file dan video controller
        _file = null;
        _videoController = null;
      });
    }
  }


  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: _showBottomSheet,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MyColors.bgformborder),
              ),
              child: _file == null
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Tambah Foto / Video'),
                  ],
                ),
              )
                  : Stack(
                children: [
                  _file!.path.endsWith('.mp4')
                      ? _videoController != null && _videoController!.value.isInitialized
                      ? VideoPlayer(_videoController!)
                      : Center(child: CircularProgressIndicator())
                      : Image.file(File(_file!.path)),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteFile,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
