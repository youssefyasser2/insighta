library;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileData>(_onFetchProfileData);
  }

  Future<void> _onFetchProfileData(
    FetchProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await http.get(
        Uri.parse('https://67b8b14a699a8a7baef4f48b.mockapi.io/api/login/${event.userId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(ProfileLoaded(data));
      } else {
        emit(ProfileError('Failed to load profile data'));
      }
    } catch (e) {
      emit(ProfileError('Error: $e'));
    }
  }
}