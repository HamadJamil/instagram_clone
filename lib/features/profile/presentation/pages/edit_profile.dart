import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';
import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
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
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Edit Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: widget.user.photoUrl == null
                      ? null
                      : NetworkImage(widget.user.photoUrl!),
                  child: widget.user.photoUrl == null
                      ? Icon(Icons.camera_alt_rounded, size: 40)
                      : null,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  label: 'Name',
                  textController: _nameController,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  label: 'Bio',
                  textController: _bioController,
                ),
                SizedBox(height: 16),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: _updateProfile,
                      child: state is ProfileLoading
                          ? SpinKitWave(color: Colors.white, size: 20.0)
                          : Text('Update Profile'),
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

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text,
        bio: _bioController.text,
      );
      context.read<ProfileCubit>().updateProfile(updatedUser);
      Navigator.pop(context, updatedUser);
    }
  }
}
