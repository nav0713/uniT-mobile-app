part of 'family_bloc.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object> get props => [];
}

class FamilyInitial extends FamilyState {}

class FamilyLoaded extends FamilyState {
  final List<FamilyBackground>? families;
  const FamilyLoaded({required this.families});
}

class DeletedState extends FamilyState {
  final bool success;
  const DeletedState({required this.success});
  @override
  List<Object> get props => [success];
}

class FamilyAddedState extends FamilyState {
  final Map<dynamic, dynamic> response;
  const FamilyAddedState({required this.response});
  @override
  List<Object> get props => [response];
}

class EmergencyContactEditedState extends FamilyState {
  final Map<dynamic, dynamic> response;
  const EmergencyContactEditedState({required this.response});
  @override
  List<Object> get props => [response];
}

class FamilyEditedState extends FamilyState {
  final Map<dynamic, dynamic> response;
  const FamilyEditedState({required this.response});
  @override
  List<Object> get props => [response];
}

class FamilyErrorState extends FamilyState {
  final String message;
  const FamilyErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class FamilyLoadingState extends FamilyState {}

class FamilyErrorAddingState extends FamilyState {
  final int relationshipId;
  final FamilyBackground familyBackground;
  const FamilyErrorAddingState(
      {required this.familyBackground, required this.relationshipId});
}

class FamilyErrorUpdatingState extends FamilyState {
  final int relationshipId;
  final FamilyBackground familyBackground;
  const FamilyErrorUpdatingState(
      {required this.familyBackground, required this.relationshipId});
}

class FamilyErrorDeletingState extends FamilyState{
  final int id;
  const FamilyErrorDeletingState({required this.id});
}
