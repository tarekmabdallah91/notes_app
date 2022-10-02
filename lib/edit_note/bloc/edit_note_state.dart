part of 'edit_note_bloc.dart';

enum EditNoteStatus { initial, loading, success, failure }

extension EditNoteStatusX on EditNoteStatus {
  bool get isLoadingOrSuccess => [
        EditNoteStatus.loading,
        EditNoteStatus.success,
      ].contains(this);
}

class EditNoteState extends Equatable {
  const EditNoteState({
    this.status = EditNoteStatus.initial,
    this.initialNote,
    this.title = '',
    this.description = '',
  });

  final EditNoteStatus status;
  final Note? initialNote;
  final String title;
  final String description;

  bool get isNewNote => initialNote == null;

  EditNoteState copyWith({
    EditNoteStatus? status,
    Note? initialNote,
    String? title,
    String? description,
  }) {
    return EditNoteState(
      status: status ?? this.status,
      initialNote: initialNote ?? this.initialNote,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [status, initialNote, title, description];
}
