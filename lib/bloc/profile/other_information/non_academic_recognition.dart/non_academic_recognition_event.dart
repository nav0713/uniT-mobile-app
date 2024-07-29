part of 'non_academic_recognition_bloc.dart';

abstract class NonAcademicRecognitionEvent extends Equatable {
  const NonAcademicRecognitionEvent();

  @override
  List<Object> get props => [];
}
//// GET EVENT
class GetNonAcademicRecognition extends NonAcademicRecognitionEvent{
  final int? profileId;
  final String? token;
  const GetNonAcademicRecognition({ this.profileId,  this.token});
}
////LOAD EVENT
class LoadNonAcademeRecognition extends NonAcademicRecognitionEvent{

  const LoadNonAcademeRecognition();
      @override
  List<Object> get props => [];
}

////SHOW ADD FORM EVENT
class ShowAddNonAcademeRecognitionForm extends NonAcademicRecognitionEvent{

}

//// SHOW EDIT FORM
class ShowEditNonAcademicRecognitionForm extends NonAcademicRecognitionEvent{
  final NonAcademicRecognition nonAcademicRecognition;
  const ShowEditNonAcademicRecognitionForm({required this.nonAcademicRecognition});
          @override
  List<Object> get props => [nonAcademicRecognition];
}

//// ADD EVENT
class AddNonAcademeRecognition extends NonAcademicRecognitionEvent{
  final int profileId;
  final String token;
  final NonAcademicRecognition nonAcademicRecognition;
  const AddNonAcademeRecognition({required this.nonAcademicRecognition, required this.profileId, required this.token});
        @override
  List<Object> get props => [nonAcademicRecognition,profileId,token];
}

//// EDIT EVENT
class EditNonAcademeRecognition extends NonAcademicRecognitionEvent{
  final NonAcademicRecognition nonAcademicRecognition;
  final String token;
  final int profileId;
  const EditNonAcademeRecognition({required this.nonAcademicRecognition, required this.profileId, required this.token});
        @override
  List<Object> get props => [nonAcademicRecognition,profileId,token];
}

//// DELETE EVENT
class DeleteNonAcademeRecognition extends NonAcademicRecognitionEvent{
  final int profileId;
  final String token;
  final List<NonAcademicRecognition> nonAcademicRecognitions;
  final NonAcademicRecognition nonAcademicRecognition;
  const DeleteNonAcademeRecognition({required this.nonAcademicRecognitions, required this.nonAcademicRecognition,required this.profileId,required this.token});
          @override
  List<Object> get props => [profileId,token,nonAcademicRecognition,nonAcademicRecognitions];

}

