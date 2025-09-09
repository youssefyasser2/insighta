part of 'profile_bloc.dart';

// الحالات (States)
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

// الحالة الأولية
final class ProfileInitial extends ProfileState {}

// حالة التحميل
final class ProfileLoading extends ProfileState {}

// حالة نجاح جلب البيانات
final class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profileData;

  const ProfileLoaded(this.profileData);

  @override
  List<Object> get props => [profileData];
}

// حالة الخطأ
final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}