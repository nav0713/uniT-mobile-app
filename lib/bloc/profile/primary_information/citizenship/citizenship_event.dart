part of 'citizenship_bloc.dart';

abstract class CitizenshipEvent extends Equatable {
  const CitizenshipEvent();

  @override
  List<Object> get props => [];
}

class GetCitizenship extends CitizenshipEvent{
  final List<Citizenship> citizenship;
  const GetCitizenship({required this.citizenship});
}
class ShowAddCitizenshipForm extends CitizenshipEvent{
  const ShowAddCitizenshipForm();
}
class LoadCitizenship extends CitizenshipEvent{
  const LoadCitizenship();
}

class EditCitizenship extends CitizenshipEvent{
  final Citizenship citizenship;
  final int profileId;
  final String token;
  final int oldCountryId;
  const EditCitizenship({required this.citizenship, required this.oldCountryId, required this.profileId, required this.token});
}
class AddCitizenship extends CitizenshipEvent{
  final int profileId;
  final String token;
  final int coiuntryId;
  final bool naturalBorn;
  const AddCitizenship({required this.coiuntryId, required this.naturalBorn, required this.profileId, required this.token});
}

class DeleteCitizenship extends CitizenshipEvent{
    final int profileId;
  final String token;
  final int coiuntryId;
  final bool naturalBorn;
  const DeleteCitizenship({required this.coiuntryId, required this.naturalBorn, required this.profileId, required this.token});
}
