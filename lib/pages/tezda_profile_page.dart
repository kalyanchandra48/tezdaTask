import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tezda_task/common_widgets/common_textfield.dart';
import 'package:tezda_task/constants/constants.dart';
import 'package:tezda_task/services/firebase_store.dart';
import 'package:tezda_task/services/local_store.dart';

ValueNotifier<XFile?> imageFile = ValueNotifier<XFile?>(null);
ValueNotifier<String> storageImageUrl = ValueNotifier<String>('');
ValueNotifier<String> useruuid = ValueNotifier<String>('');

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storageRef = FirebaseStorage.instance.ref();

  final Map<String, dynamic> data = {};
  String userUid = '';

  getProfileImage() async {
    final imageUrl =
        await storageRef.child("profiles/$userUid").getDownloadURL();
    return imageUrl;
  }

  @override
  void initState() {
    userUid = useruuid.value;
    final imageUrl = getProfileImage();
    imageUrl.then((value) {
      if (value != null) {
        storageImageUrl.value = value;
      }
    });
    print('UserUid: $userUid');
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data.addAll(documentSnapshot.data() as Map<String, dynamic>);
        print('Document data: ${documentSnapshot.data()}');
        emailcontroller.text = data['email'];
        namecontroller.text = data['name'];
      } else {
        print('Document does not exist on the database');
      }
    });
    super.initState();
  }

  TextEditingController namecontroller = TextEditingController();

  TextEditingController emailcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32.0),
              Stack(
                children: [
                  ValueListenableBuilder(
                      valueListenable: imageFile,
                      builder: (context, image, snapshot) {
                        return ValueListenableBuilder<String>(
                            valueListenable: storageImageUrl,
                            builder: (context, storageLink, snapshot) {
                              return CircleAvatar(
                                radius: 90.0,
                                backgroundImage: storageLink.isNotEmpty
                                    ? NetworkImage(storageLink)
                                    : image != null
                                        ? FileImage(File(image.path))
                                        : NetworkImage(noImage),
                              );
                            });
                      }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            imageFile.value = pickedFile;

                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child('profiles/$userUid');
                            storageRef.putFile(File(pickedFile.path),
                                SettableMetadata(contentType: 'image/jpeg'));
                          }

                          // Handle image upload button press
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Enter your name',
                prefixIcon: Icons.person,
                controller: namecontroller,
              ),
              const SizedBox(height: 8.0),
              CustomTextField(
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                controller: emailcontroller,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Handle update profile button press
                  FirebaseServices().updateFields('name', namecontroller.text);
                  FirebaseServices()
                      .updateFields('email', emailcontroller.text);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 19.0),
                ),
                child: const Text('Update Profile'),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Handle logout button press
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Perform logout operation
                            Navigator.of(context).pop();
                            LocalStore.deleteData('uid');
                            await FirebaseAuth.instance.signOut();

                            Navigator.pushNamed(context, '/login');
                            imageFile.value = null;
                            storageImageUrl.value = '';
                            namecontroller.clear();
                            emailcontroller.clear();
                            useruuid.value = '';
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
