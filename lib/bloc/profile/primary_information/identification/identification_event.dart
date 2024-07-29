part of 'identification_bloc.dart';

abstract class IdentificationEvent extends Equatable {
  const IdentificationEvent();

  @override
  List<Object> get props => [];
}
////get
class GetIdentifications extends IdentificationEvent{
   final List<Identification> identificationInformation;
   const GetIdentifications({required this.identificationInformation});
     @override
  List<Object> get props => [identificationInformation];
}
////load
class LoadIdentifications extends IdentificationEvent{
    @override
  List<Object> get props => [];
}

////show add form
class ShowAddIdentificationForm extends IdentificationEvent{

}
//// show edit form
class ShowEditIdentificationForm extends IdentificationEvent{
  final bool overseas;
  final Identification identification;
  final int profileId;
  final String token;
  const ShowEditIdentificationForm({required this.identification, required this.profileId, required this.token, required this.overseas});
       @override
  List<Object> get props => [identification,profileId,token,overseas];
}
class DeleteIdentification extends IdentificationEvent{
  final int identificationId;
  final int profileId;
  final String token;
  const DeleteIdentification({required this.identificationId, required this.profileId, required this.token});

}

//// add
class AddIdentification extends IdentificationEvent{
  final Identification identification;
  final int profileId;
  final String token;
  const AddIdentification({required this.identification, required this.profileId, required this.token});
      @override
  List<Object> get props => [identification,profileId,token];
}

//// update
class UpdateIdentifaction extends IdentificationEvent{
  final Identification identification;
  final int profileId;
  final String token;
  const UpdateIdentifaction({required this.identification, required this.profileId, required this.token});
      @override
  List<Object> get props => [identification,profileId,token];
}

class ShowErrorState extends IdentificationEvent {
  final String message;
  const ShowErrorState({required this.message});
}

