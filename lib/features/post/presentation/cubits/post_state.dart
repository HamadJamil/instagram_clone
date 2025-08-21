import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class PostPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostPageInitial extends PostPageState {}

class PostPageLoading extends PostPageState {}

class PostPageLoaded extends PostPageState {
  final List<AssetEntity> posts;
  final Future<File?> imageFile;

  PostPageLoaded(this.posts, this.imageFile);

  @override
  List<Object?> get props => [posts, imageFile];
}

class PostPagePermissionRequestDenied extends PostPageState {}

class PostPageError extends PostPageState {
  final String message;

  PostPageError(this.message);
}
