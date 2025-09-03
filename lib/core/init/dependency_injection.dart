import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram/core/repository/comment_repository.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/repository/strorage_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/features/auth/data/datasources/firebase_auth_service.dart';
import 'package:instagram/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';

class DependencyInjection {
  DependencyInjection._();
  static late final FirebaseAuth _auth;
  static late final FirebaseFirestore _firestore;
  static late final FirebaseStorage _storage;

  static late final UserRepository _userRepository;
  static late final PostRepository _postRepository;
  static late final StorageRepository _storageRepository;
  static late final FirebaseAuthService _authService;
  static late final AuthRepository _authRepository;
  static late final CommentRepository _commentRepository;

  static void initialize() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;

    _commentRepository = CommentRepository(_firestore);
    _userRepository = UserRepository(_firestore);
    _postRepository = PostRepository(_firestore);
    _storageRepository = StorageRepository(_storage);
    _authService = FirebaseAuthService(_auth);
    _authRepository = AuthRepositoryImplementation(
      _authService,
      _userRepository,
    );
  }

  static CommentRepository get commentRepository => _commentRepository;
  static UserRepository get userRepository => _userRepository;
  static PostRepository get postRepository => _postRepository;
  static StorageRepository get storageRepository => _storageRepository;
  static AuthRepository get authRepository => _authRepository;

  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;
  static FirebaseStorage get storage => _storage;
}
