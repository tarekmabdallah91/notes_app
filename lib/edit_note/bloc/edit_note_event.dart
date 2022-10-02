part of 'edit_note_bloc.dart';

abstract class EditNoteEvent extends Equatable {
  const EditNoteEvent();

  @override
  List<Object> get props => [];
}

class EditNoteTitleChanged extends EditNoteEvent {
  const EditNoteTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class EditNoteDescriptionChanged extends EditNoteEvent {
  const EditNoteDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class EditNoteSubmitted extends EditNoteEvent {
  const EditNoteSubmitted();
}
