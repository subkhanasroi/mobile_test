import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_input_chips/flutter_input_chips.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:test_youapp/common/data.dart';
import 'package:test_youapp/common/shared_data_type.dart';
import 'package:test_youapp/data/request.dart';
import 'package:test_youapp/data/sp_data.dart';
import 'package:test_youapp/models/app/user_model.dart';
import 'package:test_youapp/models/singleton_model.dart';
import 'package:test_youapp/tools/get_shio_tools.dart';
import 'package:test_youapp/tools/get_zodiac_tools.dart';
import 'dart:io';

import 'package:test_youapp/tools/permission_services.dart';
import 'package:test_youapp/views/profile/add_interest_page.dart';

class AboutProfilePage extends StatefulWidget {
  const AboutProfilePage({Key? key}) : super(key: key);

  @override
  State<AboutProfilePage> createState() => _AboutProfilePageState();
}

class _AboutProfilePageState extends State<AboutProfilePage> {
  late bool _onEdit;
  late TextEditingController _cDisplayName;
  late TextEditingController _cBirthday;
  String? _cGender;
  late TextEditingController _cHeight;
  late TextEditingController _cWeight;
  DateTime? _date;
  DateFormat? _format;
  late String _horoscope;
  late String _shio;
  File? _image;
  late SingletonModel _model;
  Request? _request;
  late bool _onUpdate;
  late bool _aboutPage;

  @override
  void initState() {
    super.initState();
    _onEdit = false;
    _date = DateTime.now();
    _shio = "--";
    _horoscope = "--";
    _model = SingletonModel.withContext(context);
    _cDisplayName =
        TextEditingController(text: _model.user!.data!.profile!.displayName);
    _cBirthday = TextEditingController(text: _format?.format(_date!));
    _cHeight = TextEditingController(text: _model.user!.data!.profile!.height);
    _cWeight = TextEditingController(text: _model.user!.data!.profile!.weight);
    _format = DateFormat('dd MMMM yyyy');
    _checkPermissions();
    _request = Request();
    _onUpdate = false;
    _aboutPage = false;
  }

  void _getImageGallery() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void _checkPermissions() async {
    await PermissionService.reqAllPermissions();
  }

  void _updateProfile() async {
    if (!_onUpdate) {
      setState(() {
        _onUpdate = true;
      });
      await _request!.youApp.user
          .update(
        id: _model.user!.data!.id,
        displayName: _cDisplayName.text,
        gender: _cGender,
        birthday: _format?.format(_date!),
        zodiac: _horoscope,
        shio: _shio,
        height: _cHeight.text,
        weight: _cWeight.text,
      )
          .then((res) async {
        if (res.statusCode == 200 || res.statusCode == 201) {
          // setState(() {
          //   _model.user!.data = Data.fromJson(res.data['data']);
          //   _data.saveToSP(kDUser, SharedDataType.string,
          //       jsonEncode(_model.user!.data!.toJson()));
          // });
        }
      }).catchError((e) {
        setState(() {
          _onUpdate = false;
        });
      });
      await Future.delayed(const Duration(seconds: 2));
      if (_image != null) {
        await _request!.youApp.user
            .updatePhoto(id: _model.user!.data!.id, image: _image)
            .then((res) async {
          if (res.statusCode == 200 || res.statusCode == 201) {
            print(res.data['data']);
            setState(() {
              _model.data = Data.fromJson(res.data['data']);
              // _data.saveToSP(kDUser, SharedDataType.string,
              //     jsonEncode(_model.user!.data!.toJson()));
            });
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              _onUpdate = false;
              _onEdit = false;
              _aboutPage = true;
            });
          }
        }).catchError((e) {
          setState(() {
            _onUpdate = false;
          });
        });
      }
    }
    setState(() {
      _onUpdate = false;
      // _onEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        HeroIcons.chevron_left,
                        color: Colors.white,
                      ),
                      Text(
                        "Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    _model.user!.data!.email!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  const Icon(
                    HeroIcons.ellipsis_horizontal,
                    color: Colors.white,
                  )
                ]),
          ),
        ),
      ),
      backgroundColor: HexColor("09141A"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _model.data != null
              ? Container(
                  padding: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * .25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "http://192.168.188.39:3000${_model.data!.profile!.photoProfile}"),
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(.4), BlendMode.overlay)),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "@${_model.data!.profile!.displayName}, ${2023 - int.parse(_model.data!.profile!.birthday.substring(_model.data!.profile!.birthday.length - 4))}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _model.data!.profile!.gender,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: HexColor("09141A")),
                            child: Center(
                                child: Text(
                              _model.data!.profile!.zodiac,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: HexColor("09141A")),
                            child: Center(
                                child: Text(
                              _model.data!.profile!.shio,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * .25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.3)),
                ),
          const SizedBox(
            height: 32,
          ),
          _aboutPage
              ? Container(
                  padding: const EdgeInsets.only(
                      left: 32, top: 8, right: 8, bottom: 16),
                  height: MediaQuery.of(context).size.height * .30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "About",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _onEdit = true;
                                _aboutPage = false;
                              });
                            },
                            child: const Icon(
                              HeroIcons.pencil,
                              size: 14,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: [
                              Text(
                                "Birthday:",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.3),
                                    fontSize: 14),
                              ),
                              Text(
                                "${_model.data!.profile!.birthday} (Age ${2023 - int.parse(_model.data!.profile!.birthday.substring(_model.data!.profile!.birthday.length - 4))})",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                "Horoscope:",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.3),
                                    fontSize: 14),
                              ),
                              Text(
                                _model.data!.profile!.zodiac,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                "Shio:",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.3),
                                    fontSize: 14),
                              ),
                              Text(
                                _model.data!.profile!.shio,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                "Height:",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.3),
                                    fontSize: 14),
                              ),
                              Text(
                                "${_model.data!.profile!.height} cm",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                "Weight:",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.3),
                                    fontSize: 14),
                              ),
                              Text(
                                "${_model.data!.profile!.weight} kg",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(
                      left: 32, top: 8, right: 8, bottom: 16),
                  height: _onEdit == false
                      ? MediaQuery.of(context).size.height * .15
                      : MediaQuery.of(context).size.height * .80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "About",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          _onEdit == false
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      _onEdit = true;
                                    });
                                  },
                                  child: const Icon(
                                    HeroIcons.pencil,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                )
                              : InkWell(
                                  onTap: () => _updateProfile(),
                                  child: _onUpdate
                                      ? const SpinKitCircle(
                                          size: 10,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "Save & Update",
                                          style: TextStyle(
                                            color: HexColor("D1B000"),
                                            fontSize: 14,
                                          ),
                                        ),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      _onEdit == false
                          ? Text(
                              "Add in your your to help others know you better",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.5),
                                fontSize: 14,
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => _getImageGallery(),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.3),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: _image == null
                                            ? Icon(HeroIcons.plus,
                                                color: HexColor("D1B000"))
                                            : Image.file(
                                                _image ?? File(""),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    _image == null
                                        ? const Text(
                                            "Add image",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )
                                        : const Text(
                                            "Image added",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )
                                  ],
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Display name:",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.3),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: TextFormField(
                                          controller: _cDisplayName,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            hintText: "Enter name",
                                            hintStyle: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(.3),
                                                fontSize: 14),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Gender:",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.3),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Colors.white.withOpacity(.1)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            dropdownColor: HexColor("09141A"),

                                            style: const TextStyle(
                                                color: Colors.white),
                                            icon: const Icon(
                                                HeroIcons.chevron_down),
                                            isExpanded: true,
                                            value: _cGender,
                                            items: <String>['Male', 'Female']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: SizedBox(
                                                  width: 130,
                                                  child: Text(
                                                    value,
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            // Step 5.
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _cGender = newValue!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "Birthday:",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.3),
                                              fontSize: 14),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 6,
                                          child: TextFormField(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return SizedBox(
                                                      height: 250,
                                                      child: ScrollDatePicker(
                                                        minimumDate:
                                                            DateTime(1945),
                                                        maximumDate:
                                                            DateTime.now(),
                                                        selectedDate: _date!,
                                                        locale:
                                                            const Locale('en'),
                                                        onDateTimeChanged:
                                                            (DateTime value) {
                                                          setState(() {
                                                            _date = value;
                                                            _cBirthday.text =
                                                                _format!.format(
                                                                    _date!);
                                                          });
                                                          if (_date != null) {
                                                            setState(() {
                                                              _horoscope = Zodiac()
                                                                  .getZodiac(_date
                                                                      .toString())!;
                                                              _shio = Shio()
                                                                  .getShio(_date
                                                                      .toString())!;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    );
                                                  });
                                            },
                                            controller: _cBirthday,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              hintText: "DD MM YYYY",
                                              hintStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(.3),
                                                  fontSize: 14),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Horoscope:",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.3),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white
                                                    .withOpacity(.1)),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  _horoscope,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                )),
                                          ),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Shio:",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.3),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white
                                                    .withOpacity(.1)),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  _shio,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                )),
                                          ),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Height:",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.3),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _cHeight,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            hintText: "Add height",
                                            hintStyle: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(.3),
                                                fontSize: 14),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Weight:",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(.3),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _cWeight,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            hintText: "Add weight",
                                            hintStyle: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(.3),
                                                fontSize: 14),
                                          ),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
          const SizedBox(
            height: 32,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 32, top: 8, right: 8, bottom: 16),
            height: MediaQuery.of(context).size.height * .25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Interest",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () => Get.to(const AddInterestPage()),
                      child: const Icon(
                        HeroIcons.pencil,
                        size: 14,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                _model.interest == null
                    ? Text(
                        "Add in your interest to find a better match",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.5),
                          fontSize: 14,
                        ),
                      )
                    : IgnorePointer(
                        ignoring: true,
                        child: FlutterInputChips(
                          maxChips: 5,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          initialValue: _model.interest ?? [],
                          onChanged: (v) {},
                          padding: const EdgeInsets.all(10),
                          inputDecoration: const InputDecoration(
                            filled: false,
                            border: InputBorder.none,
                          ),
                          chipTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          chipSpacing: 8,
                          chipCanDelete: false,
                          chipBackgroundColor: Colors.blueGrey,
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
