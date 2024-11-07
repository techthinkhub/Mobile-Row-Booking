import 'dart:io';
import 'package:customer_bengkelly/app/data/data_endpoint/createkendaraan.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';
import '../../../data/data_endpoint/merekkendaraan.dart';
import '../../../data/data_endpoint/tipekendaraan.dart';
import '../../../data/endpoint.dart';
import '../../../data/publik.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  final dio.Dio _dio = dio.Dio();
  var futureMerek = Future<MerekKendaraan>.value(MerekKendaraan(data: [])).obs;
  var futureTipeKendaraan = Future<TipeKendaraan>.value(TipeKendaraan(data: [])).obs;
  var selectedMerek = ''.obs;
  var selectedTipe = ''.obs;
  var selectedMerekId = 0.obs;
  var selectedTipeID = 0.obs;
  var selectedTransmisi = ''.obs;
  var selectedKategory = ''.obs;
  String? imageUrl;

  // Observables for form fields
  final nopol = ''.obs;
  final nomorlambung = ''.obs;
  final kmterakhir = ''.obs;
  final tahun = ''.obs;
  final warna = ''.obs;

  final isLoading = false.obs;
  final isFormValid = false.obs;

  final nopolController = TextEditingController();
  final nomorlambungController = TextEditingController();
  final kmterakhirController = TextEditingController();
  final tahunController = TextEditingController();
  final warnaController = TextEditingController();

  final _packageName = ''.obs;
  String get packageName => _packageName.value;
  final InAppUpdate inAppUpdate = InAppUpdate();

  @override
  void onInit() {
    super.onInit();
    loadMerek();
    bindTextControllers();
    validateForm();
  }
  void loadMerek() {
    futureMerek.value = API.merekid();
  }
  void resetForm() {
    nopolController.clear();
    nomorlambungController.clear();
    kmterakhirController.clear();
    tahunController.clear();
    warnaController.clear();
    nopol.value = '';
    nomorlambung.value = '';
    kmterakhir.value = '';
    tahun.value = '';
    warna.value = '';
  }
  @override
  void onReady() {
    super.onReady();
    resetForm();
  }
  @override
  void onClose() {
    nopolController.dispose();
    nomorlambungController.dispose();
    kmterakhirController.dispose();
    tahunController.dispose();
    warnaController.dispose();
    super.onClose();
  }
  void bindTextControllers() {
    nopolController.addListener(() => nopol.value = nopolController.text);
    nomorlambungController.addListener(() => nomorlambung.value = nomorlambungController.text);
    kmterakhirController.addListener(() => kmterakhir.value = kmterakhirController.text);
    tahunController.addListener(() => tahun.value = tahunController.text);
    warnaController.addListener(() => warna.value = warnaController.text);

    // Observe changes to observables
    everAll([
      nopol,
      selectedMerek,
      selectedKategory,
      selectedTransmisi,
      nomorlambung,
      kmterakhir,
      tahun,
    ], (_) => validateForm());
  }

  void validateForm() {
    isFormValid.value = nopol.value.isNotEmpty &&
        selectedMerek.value.isNotEmpty &&
        selectedKategory.value.isNotEmpty &&
        selectedTransmisi.value.isNotEmpty &&
        nomorlambung.value.isNotEmpty &&
        kmterakhir.value.isNotEmpty &&
        tahun.value.isNotEmpty;
  }

  Future<void> CreateKendaraan() async {
    if (!isFormValid.value) {
      Get.snackbar('Gagal Registrasi', 'Semua bidang harus diisi',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final registerResponse = await API.CreateKendaraanID(
        nopolisi: nopol.value,
        idmerk: selectedMerekId.value.toString(),
        idtipe: selectedTipeID.value.toString(),
        warna: warna.value,
        tahun: tahun.value,
        nomorlambung: nomorlambung.value,
        categoryname: selectedKategory.value,
        transmission: selectedTransmisi.value,
        kmterakhir: kmterakhir.value,
      );

      if (registerResponse != null && registerResponse.status == true) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar('Error', 'Terjadi kesalahan saat registrasi',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Berhasil', 'Data kendaraan anda sudah dapat melakukan Booking service',
          backgroundColor: Colors.blue,
          colorText: Colors.white);
      Get.offAllNamed(Routes.HOME);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update(); // Update UI
    }
  }

  Future<void> updateProfile(String name, String email, String hp, String alamat) async {
    String url = 'https://api.realauto.co.id/api/customer-update-profile';
    final token = Publics.controller.getToken.value ?? '';

    dio.FormData formData = dio.FormData.fromMap({
      'nama': name,
      'email': email,
      'hp': hp,
      'alamat': alamat,
      if (selectedImage != null)
        'gambar': await dio.MultipartFile.fromFile(selectedImage!.path, filename: 'profile.jpg'),
    });

    try {
      dio.Response response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed(Routes.HOME);
        Get.snackbar('Success', 'Profile updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);

      } else {
        Get.snackbar('Error', 'Failed to update profile',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void showUpdateDialog() {}
}
