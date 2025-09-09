part of 'profile_bloc.dart';

// الأحداث (Events)
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

// حدث جلب بيانات المستخدم
class FetchProfileData extends ProfileEvent {
  final String userId;

  const FetchProfileData(this.userId);

  @override
  List<Object> get props => [userId];
}