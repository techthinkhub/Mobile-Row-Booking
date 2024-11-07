import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../../data/data_endpoint/customkendaraan.dart';
import '../../../data/data_endpoint/kendaraandepartemen.dart';
import '../../../data/data_endpoint/kendaraanpic.dart';
import '../../../data/data_endpoint/lokasi.dart' as LokasiEndpoint;
import '../../../data/data_endpoint/lokasi.dart';
import '../../../data/data_endpoint/jenisservice.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
import 'package:image/image.dart' as img;

class EmergencyBookingViewController extends GetxController {
  var Keluhan = ''.obs;

  var selectedService = Rx<JenisServices?>(null);
  var selectedLocation = Rx<String?>(null);
  var selectedLocationID = Rx<DataLokasi?>(null);
  var selectedDate = Rx<DateTime?>(null);
  var selectedTime = Rx<TimeOfDay?>(null);

  var tipeListPIC = <Kendaraanpic>[].obs;
  var filteredListPIC = <Kendaraanpic>[].obs;
  var selectedTransmisiPIC = Rx<Kendaraanpic?>(null);

  var tipeList = <DataKendaraan>[].obs;
  var filteredList = <DataKendaraan>[].obs;
  var selectedTransmisi = Rx<DataKendaraan?>(null);

  var tipeListDepartemen = <KendaraanDepartemen>[].obs;
  var filteredListDepartemen = <KendaraanDepartemen>[].obs;
  var selectedTransmisiDepartemen = Rx<KendaraanDepartemen?>(null);

  var serviceList = <JenisServices>[].obs;
  var isLoading = true.obs;

  var calendarFormat = CalendarFormat.month.obs;
  var focusedDay = DateTime
      .now()
      .obs;
  var isDateSelected = false.obs;

  late GoogleMapController mapController;
  var currentPosition = Rxn<Position>();
  var markers = <Marker>[].obs;
  var locationData = <LokasiEndpoint.DataLokasi>[].obs;
  var currentAddress = 'Mengambil lokasi...'.obs;
  final panelController = PanelController();
  bool isManual = false;
  final ImagePicker _picker = ImagePicker();
  RxList<XFile> imageFiles = <XFile>[].obs;
  RxList<XFile> videoFiles = <XFile>[].obs;
  Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(null);
  final int _maxFileSize = 1 * 1024 * 1024; // 1 MB

  Future<void> pickMedia({required bool pickImages, required bool fromCamera}) async {
    if (fromCamera) {
      if (pickImages) {
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          await _handleImagePicked(pickedFile);
        }
      } else {
        final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.camera);
        if (pickedFile != null) {
          await _handleVideoPicked(pickedFile);
        }
      }
    } else {
      if (pickImages) {
        final List<XFile>? pickedFiles = await _picker.pickMultiImage();
        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          await _handleMultipleImagesPicked(pickedFiles);
        }
      } else {
        final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
        if (pickedFile != null) {
          await _handleVideoPicked(pickedFile);
        }
      }
    }
  }

  Future<void> _handleImagePicked(XFile pickedFile) async {
    File imageFile = File(pickedFile.path);
    File? compressedFile = await compressImage(imageFile);

    if (compressedFile != null) {
      final fileSize = await compressedFile.length();

      if (fileSize <= _maxFileSize) {
        imageFiles.add(XFile(compressedFile.path));
        videoController.value?.dispose();
      } else {
        _showErrorMessage("File size exceeds 1 MB even after compression. Please select a smaller file.");
      }
    } else {
      _showErrorMessage("Failed to compress image.");
    }
  }

  Future<void> _handleMultipleImagesPicked(List<XFile> pickedFiles) async {
    for (XFile pickedFile in pickedFiles) {
      File imageFile = File(pickedFile.path);
      File? compressedFile = await compressImage(imageFile);

      if (compressedFile != null) {
        final fileSize = await compressedFile.length();

        if (fileSize <= _maxFileSize) {
          imageFiles.add(XFile(compressedFile.path));
        } else {
          _showErrorMessage("File size exceeds 1 MB even after compression. Please select a smaller file.");
        }
      } else {
        _showErrorMessage("Failed to compress image.");
      }
    }
  }

  Future<void> _handleVideoPicked(XFile pickedFile) async {
    videoFiles.add(pickedFile);
    videoController.value = VideoPlayerController.file(File(pickedFile.path))
      ..initialize().then((_) {
        videoController.value?.play();
      });
  }

  Future<File?> compressImage(File imageFile) async {
    final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image == null) return null;

    img.Image resizedImage = img.copyResize(image, width: 1024);
    final Uint8List jpegData = img.encodeJpg(resizedImage, quality: 85);
    final File compressedFile = File('${imageFile.parent.path}/compressed_${imageFile.uri.pathSegments.last}');
    await compressedFile.writeAsBytes(jpegData);

    return compressedFile;
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile(
                icon: Icons.photo_library,
                title: 'Pilih Media dari Galeri',
                onTap: () {
                  Navigator.pop(context);
                  _showMediaOptions(context, fromCamera: false);
                },
              ),
              _buildListTile(
                icon: Icons.camera_alt,
                title: 'Ambil Foto dari Kamera',
                onTap: () {
                  Navigator.pop(context);
                  pickMedia(pickImages: true, fromCamera: true);
                },
              ),
              _buildListTile(
                icon: Icons.videocam,
                title: 'Ambil Video dari Kamera',
                onTap: () {
                  Navigator.pop(context);
                  pickMedia(pickImages: false, fromCamera: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMediaOptions(BuildContext context, {required bool fromCamera}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile(
                icon: Icons.photo_library,
                title: 'Pilih Foto dari Galeri',
                onTap: () {
                  Navigator.pop(context);
                  pickMedia(pickImages: true, fromCamera: fromCamera);
                },
              ),
              _buildListTile(
                icon: Icons.video_library,
                title: 'Pilih Video dari Galeri',
                onTap: () {
                  Navigator.pop(context);
                  pickMedia(pickImages: false, fromCamera: fromCamera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void deleteFile(XFile file, bool isVideo) {
    // Dispose videoController jika menghapus video
    if (isVideo) {
      videoController.value?.dispose();
    }

    // Hapus file fisik
    final fileToDelete = File(file.path);
    if (fileToDelete.existsSync()) {
      fileToDelete.deleteSync();
    }

    // Hapus file dari daftar sesuai jenisnya
    if (isVideo) {
      videoFiles.remove(file);
    } else {
      imageFiles.remove(file);
    }
  }


  Future<void> fetchAndSetDefaultLocation() async {
    var lokasi = await API.LokasiBengkellyID();
    if (lokasi.data != null && lokasi.data!.isNotEmpty) {
      var firstLocation = lokasi.data!.first;
      selectedLocationID.value = firstLocation; // Set default location
      selectedLocation.value = '${firstLocation.name}';
    }
  }
  void search(String query) {
    if (query.isEmpty) {
      filteredList.value = tipeList;
    } else {
      filteredList.value = tipeList.where((item) {
        final lowerQuery = query.toLowerCase();
        return (item.noPolisi?.toLowerCase().contains(lowerQuery) ?? false) ||
            (item.vinnumber?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }
  }


  void resetSearch() {
    filteredList.value = tipeList;
  }

  bool isFormValidEmergency() {
    return selectedTransmisi.value != null &&
        selectedLocation.value != null &&
        imageFiles.value != null &&
        Keluhan.value.isNotEmpty;
  }
  bool isFormValidEmergencypic() {
    return selectedTransmisiPIC.value != null &&
        selectedLocation.value != null &&
        imageFiles.value != null &&
        Keluhan.value.isNotEmpty;
  }
  bool isFormValidEmergencyDepartemen() {
    return selectedTransmisiDepartemen.value != null &&
        selectedLocation.value != null &&
        imageFiles.value != null &&
        Keluhan.value.isNotEmpty;
  }
  void selectTransmisi(DataKendaraan value) {
    selectedTransmisi.value = value;
  }
  void selectLocationemergency(DataLokasi locationData) {
    selectedLocationID.value = locationData;
    final id = locationData.geometry?.location?.id ?? '';
    final name = locationData.name ?? '';
    selectedLocation.value = '$name';
  }
  void selectService(JenisServices value) {
    selectedService.value = value;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDate.value = selectedDay;
    this.focusedDay.value = focusedDay;
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void onPageChanged(DateTime focusedDay) {
    this.focusedDay.value = focusedDay;
  }

  void selectDate() {
    if (selectedDate.value != null) {
      isDateSelected.value = true;
    }
  }

  void selectTime(Duration duration) {
    selectedTime.value = TimeOfDay(
      hour: duration.inHours,
      minute: duration.inMinutes % 60,
    );
  }

  void confirmSelection(BuildContext context) {
    if (selectedDate.value != null && selectedTime.value != null) {
      final selectedDateTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );
      Navigator.pop(context, selectedDateTime);
    }
  }

  Future<void> EmergencyServiceVale() async {
    if (isFormValidEmergencyDepartemen()) {
      await _handleEmergencyService(
        idKendaraan: selectedTransmisiDepartemen.value!.id.toString(),
        isPIC: true,
      );
    }

    if (isFormValidEmergencypic()) {
      await _handleEmergencyService(
        idKendaraan: selectedTransmisiPIC.value!.id.toString(),
        isPIC: true,
      );
    }

    if (isFormValidEmergency()) {
      await _handleEmergencyService(
        idKendaraan: selectedTransmisi.value!.id.toString(),
        isPIC: false,
      );
    }
  }

  Future<void> _handleEmergencyService({
    required String idKendaraan,
    required bool isPIC,
  }) async {
    if (Keluhan.value == null || idKendaraan.isEmpty) {
      Get.snackbar(
        'Gagal Emergency Service',
        'Informasi lokasi tidak lengkap',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final idcabang = selectedLocationID.value?.geometry?.location?.id?.toString();

      if (idcabang == null) {
        Get.snackbar(
          'Gagal Emergency Service',
          'ID lokasi tidak tersedia',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      final mediaPaths = [
        ...imageFiles.map((file) => file.path),
        ...videoFiles.map((file) => file.path),
      ];

      final registerResponse = await API.EmergencyServiceValeID(
        idcabang: idcabang,
        keluhan: Keluhan.value!,
        idkendaraan: idKendaraan,
        location: locationController.text ?? '',
        locationname: alamatmanualController.text ?? '',
        mediaPaths: mediaPaths, // Pass the list of file paths
      );

      if (registerResponse != null && registerResponse.status == true) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar('Error', 'Terjadi kesalahan saat Emergency Service',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } on DioError catch (e) {
      _handleDioError(e);
    } catch (e) {
      print('Error during emergency Service: $e');
      Get.snackbar('Gagal emergency Service', 'Kendaraan anda sudah Terdaftar Sebelumnya',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }



  void _handleDioError(DioError e) {
    if (e.response != null) {
      print('Error Response data: ${e.response!.data}');
      print('Error sending request: ${e.message}');
    } else {
      print('Error sending request: ${e.message}');
    }
    Get.snackbar('Gagal emergency Service', 'Kendaraan anda sudah Terdaftar Sebelumnya',
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  }


  Future<void> fetchServiceList() async {
    isLoading.value = true;
    var jenisservice = await API.JenisServiceID();
    if (jenisservice != null) {
      serviceList.value = jenisservice.dataservice ?? [];
    }
    isLoading.value = false;
  }

  Future<void> fetchTipeList() async {
    isLoading.value = true;
    try {
      var customerKendaraan = await API.PilihKendaraan();
      var KendaraanPIC = await API.PilihKendaraanPIC();
      var KendaraanDepartemen = await API.PilihKendaraanDepartemen();
      //Depertemen
      if (KendaraanDepartemen != null) {
        tipeListDepartemen.value = (KendaraanDepartemen.dataDepartemen?.kendaraan ?? []);
        filteredListDepartemen.value = tipeListDepartemen.value;

        if (tipeListDepartemen.isNotEmpty) {
          selectedTransmisiDepartemen.value = tipeListDepartemen.first;
        }
      } else {
        tipeListDepartemen.value = [];
        filteredListDepartemen.value = [];
        selectedTransmisiDepartemen.value = null;
      }
      //PIC
      if (KendaraanPIC != null) {
        tipeListPIC.value = (KendaraanPIC.dataPic?.kendaraan ?? []).cast<Kendaraanpic>();
        filteredListPIC.value = tipeListPIC.value;

        if (tipeListPIC.isNotEmpty) {
          selectedTransmisiPIC.value = tipeListPIC.first;
        }
      } else {
        tipeListPIC.value = [];
        filteredListPIC.value = [];
        selectedTransmisiPIC.value = null;
      }
//Pelanggan
      if (customerKendaraan != null) {
        tipeList.value = customerKendaraan.datakendaraan ?? [];
        filteredList.value = tipeList.value;

        if (tipeList.isNotEmpty) {
          selectedTransmisi.value = tipeList.first;
        }
      } else {
        tipeList.value = [];
        filteredList.value = [];
        selectedTransmisi.value = null;
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTipeList();
    fetchServiceList();
    fetchAndSetDefaultLocation();
    _checkPermissions();
  }
  Position? _currentPosition;
  var _getCurrentLocation = 'Mengambil lokasi...'.obs;
  TextEditingController locationController = TextEditingController();
  TextEditingController alamatmanualController = TextEditingController();

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    print('Permission status: $status');
    if (status.isGranted) {
      print('Permission already granted');
      await getCurrentLocation();
      await fetchLocations();
    } else {
      var requestedStatus = await Permission.location.request();
      print('Requested permission status: $requestedStatus');
      if (requestedStatus.isGranted) {
        print('Permission granted');
        await getCurrentLocation();
        await fetchLocations();
      } else {
        print('Permission denied');
        SnackBar(
          content: Text('Location permission status unknown'),
        );
      }
    }
  }
  Future<void> getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.value!.latitude, currentPosition.value!.longitude);

      Placemark place = placemarks[0];

      currentAddress.value = "${place.locality}, ${place.subAdministrativeArea}";
    } catch (e) {
      print('Error getting address: $e');
    }
  }
  Future<void> getCurrentLocation() async {
    try {
      currentPosition.value = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current position: ${currentPosition.value}');
      getAddressFromLatLng();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }
  Future<void> getCurrentLocation2() async {
    try {
      currentPosition.value = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current position: ${currentPosition.value}');
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> fetchLocations() async {
    try {
      final lokasi = await API.LokasiBengkellyID();
      if (lokasi.data != null && currentPosition.value != null) {
        locationData.value = lokasi.data!;
        for (var data in lokasi.data!) {
          final location = data.geometry?.location;
          if (location != null && location.lat != null && location.lng != null) {
            print('Fetched location: lat=${location.lat}, lng=${location.lng}');
            final latLng = LatLng(double.parse(location.lat!), double.parse(location.lng!));
            final distance = calculateDistance(
              currentPosition.value!.latitude,
              currentPosition.value!.longitude,
              latLng.latitude,
              latLng.longitude,
            );
            print('Adding marker at: $latLng');
            markers.add(
              Marker(
                markerId: MarkerId(location.id.toString()),
                position: latLng,
                infoWindow: InfoWindow(
                  title: data.name,
                  snippet: 'Distance: ${distance.toStringAsFixed(2)} km',
                ),
                onTap: () {
                  selectedLocationID.value = data;
                },
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((endLatitude - startLatitude) * p) / 2 +
        cos(startLatitude * p) * cos(endLatitude * p) * (1 - cos((endLongitude - startLongitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
