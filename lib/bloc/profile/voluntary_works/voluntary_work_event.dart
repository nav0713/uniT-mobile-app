part of 'voluntary_work_bloc.dart';

abstract class VoluntaryWorkEvent extends Equatable {
  const VoluntaryWorkEvent();

  @override
  List<Object> get props => [];
}

class GetVoluntarWorks extends VoluntaryWorkEvent {
  final int profileId;
  final String token;
  const GetVoluntarWorks({required this.profileId, required this.token});
  @override
  List<Object> get props => [profileId, token];
}

class ShowAddVoluntaryWorks extends VoluntaryWorkEvent {}

class ShowEditVoluntaryWorks extends VoluntaryWorkEvent {
  final VoluntaryWork work;
  final int profileId;
  final String token;
  final bool isOverseas;

  const ShowEditVoluntaryWorks(
      {required this.profileId,
      required this.token,
      required this.work,
      required this.isOverseas});
  @override
  List<Object> get props => [profileId, token, work];
}

class LoadVoluntaryWorks extends VoluntaryWorkEvent {}

class ShowErrorState extends VoluntaryWorkEvent {
  final String message;
  const ShowErrorState({required this.message});
}

class UpdateVolunataryWork extends VoluntaryWorkEvent{
        final int oldPosId;
      final int oldAgencyId;
      final String oldFromDate;
      final VoluntaryWork work;
      final int profileId;
      final String token;
      const UpdateVolunataryWork({required this.oldAgencyId, required this.oldFromDate, required this.oldPosId, required this.profileId, required this.token, required this.work});
}
class AddVoluntaryWork extends VoluntaryWorkEvent {
  final int profileId;
  final String token;
  final VoluntaryWork work;
  const AddVoluntaryWork(
      {required this.profileId, required this.token, required this.work});
  @override
  List<Object> get props => [profileId, token, work];
}

class DeleteVoluntaryWork extends VoluntaryWorkEvent {
  final String token;
  final int profileId;
  final VoluntaryWork work;
  const DeleteVoluntaryWork(
      {required this.profileId, required this.token, required this.work});
  @override
  List<Object> get props => [profileId, token, work];
}
class AddAttachment extends VoluntaryWorkEvent{
  final String categoryId;
  final String attachmentModule;
  final List<String> filePaths;
  final String token;
  final String profileId;
  const AddAttachment({required this.attachmentModule, required this.filePaths, required this.categoryId, required this.profileId, required this.token});
  @override
  List<Object> get props => [categoryId,attachmentModule,filePaths, token,profileId];
}
