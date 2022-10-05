part of 'edit_note_cubit.dart';

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
    this.body = '',
    this.imageUrl = '',
  });

  final EditNoteStatus status;
  final Note? initialNote;
  final String title;
  final String body;
  final String imageUrl;

  bool get isNewNote => initialNote == null;

  EditNoteState copyWith({
    EditNoteStatus? status,
    Note? initialNote,
    String? title,
    String? body,
    String? imageUrl,
  }) {
    return EditNoteState(
      status: status ?? this.status,
      initialNote: initialNote ?? this.initialNote,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [status, initialNote, title, body, imageUrl];
}


