import 'package:mocktail/mocktail.dart';
import 'package:post_app/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:post_app/features/posts/data/datasources/remote/post_remote_data_source.dart';

/// Mock implementation of PostLocalDataSource for testing
class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

/// Mock implementation of PostRemoteDataSource for testing
class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}
