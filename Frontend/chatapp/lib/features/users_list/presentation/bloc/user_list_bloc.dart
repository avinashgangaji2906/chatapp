// lib/features/all_users/presentation/bloc/user_list_bloc.dart
import 'package:chatapp/features/users_list/domain/entity/user_entity.dart';
import 'package:chatapp/features/users_list/domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserRepository userRepository;

  UserListBloc({required this.userRepository}) : super(UserListInitial()) {
    on<FetchAllUsers>((event, emit) async {
      emit(UserListLoading());
      try {
        final users = await userRepository.getAllUsers();
        emit(UserListLoaded(users));
      } catch (e) {
        emit(UserListError(e.toString()));
      }
    });
  }
}
