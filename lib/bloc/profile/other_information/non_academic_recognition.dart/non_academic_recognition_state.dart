part of 'non_academic_recognition_bloc.dart';

abstract class NonAcademicRecognitionState extends Equatable {
  const NonAcademicRecognitionState();

  @override
  List<Object> get props => [];
}

class NonAcademicRecognitionInitial extends NonAcademicRecognitionState {}

////LOADING STATE
class NonAcademicRecognitionLoadingState extends NonAcademicRecognitionState {}

////LOADED STATE
class NonAcademicRecognitionLoadedState extends NonAcademicRecognitionState {
  final List<NonAcademicRecognition> nonAcademicRecognition;
  const NonAcademicRecognitionLoadedState(
      {required this.nonAcademicRecognition});
  @override
  List<Object> get props => [];
}

////DELETED STATE
class NonAcademeRecognitionDeletedState extends NonAcademicRecognitionState {
  final List<NonAcademicRecognition> nonAcademicRecognitions;
  final bool success;
  const NonAcademeRecognitionDeletedState(
      {required this.nonAcademicRecognitions, required this.success});
  @override
  List<Object> get props => [nonAcademicRecognitions, success];
}

class NonAcademeRecognitionEditedState extends NonAcademicRecognitionState{
    final List<NonAcademicRecognition> nonAcademicRecognitions;
  final Map<dynamic,dynamic> response;
  const NonAcademeRecognitionEditedState(
      {required this.nonAcademicRecognitions, required this.response});
  @override
  List<Object> get props => [nonAcademicRecognitions, response];
}

////ADDED STATE
class NonAcademeRecognitionAddedState extends NonAcademicRecognitionState {
  final List<NonAcademicRecognition> nonAcademicRecognition;
  final Map<dynamic, dynamic> response;
  const NonAcademeRecognitionAddedState(
      {required this.nonAcademicRecognition, required this.response});
  @override
  List<Object> get props => [nonAcademicRecognition, response];
}

////ADDING STATE
class AddNonAcademeRecognitionState extends NonAcademicRecognitionState {
  final List<Agency> agencies;
  final List<Category> agencyCategories;
  const AddNonAcademeRecognitionState(
      {required this.agencies, required this.agencyCategories});
  @override
  List<Object> get props => [agencies, agencyCategories];
}

class EditNonAcademeRecognitionState extends NonAcademicRecognitionState {
  final List<Agency> agencies;
  final List<Category> agencyCategories;
  final NonAcademicRecognition nonAcademicRecognition;
  const EditNonAcademeRecognitionState({required this.agencies, required this.agencyCategories,required this.nonAcademicRecognition});
    @override
  List<Object> get props => [agencies, agencyCategories,nonAcademicRecognition];
}

////ERROR STATE
class NonAcademicRecognitionErrorState extends NonAcademicRecognitionState {
  final String message;
  const NonAcademicRecognitionErrorState({required this.message});

  @override
  List<Object> get props => [];
}

class AddNonAcademeRecognitionError extends NonAcademicRecognitionState{
    final NonAcademicRecognition nonAcademicRecognition;

  const AddNonAcademeRecognitionError({required this.nonAcademicRecognition});
}


class DeleteNonAcademeRecognitionError extends NonAcademicRecognitionState{
  final List<NonAcademicRecognition> nonAcademicRecognitions;
  final NonAcademicRecognition nonAcademicRecognition;

  const DeleteNonAcademeRecognitionError({required this.nonAcademicRecognitions, required this.nonAcademicRecognition});
}