import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/utils/utils.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';
import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';
import 'package:instagram/features/profile/presentation/cubits/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final UserModel user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late GlobalKey<FormState> _formKey;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        } else if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _showImagePickerBottomSheet,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _getProfileImage(),
                    child:
                        _selectedImage == null && widget.user.photoUrl == null
                        ? Icon(Icons.camera_alt_rounded, size: 40)
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  label: 'Name',
                  textController: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  label: 'Bio',
                  textController: _bioController,
                ),
                SizedBox(height: 32),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: state is ProfileLoading
                            ? SpinKitCircle(color: Colors.white, size: 20.0)
                            : Text('Update Profile'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (widget.user.photoUrl != null) {
      return NetworkImage(widget.user.photoUrl!);
    }
    return null;
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
      );
      context.read<ProfileCubit>().update(
        user: updatedUser,
        profilePhoto: _selectedImage,
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 236,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('Pick from Gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  final File? imageFile = await imagePickerFromGallery();
                  if (imageFile != null && mounted) {
                    setState(() {
                      _selectedImage = imageFile;
                    });
                  }
                },
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt_outlined),
                label: Text('Take a Photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  final File? imageFile = await imagePickerFromCamera();
                  if (imageFile != null && mounted) {
                    setState(() {
                      _selectedImage = imageFile;
                    });
                  }
                },
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Remove Photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
