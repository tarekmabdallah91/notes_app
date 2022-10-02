import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_repository/note_repository.dart';


part 'edit_note_event.dart';
part 'edit_note_state.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  EditNoteBloc({
    required NotesRepository notesRepository,
    required Note? initialNote,
  })  : _notesRepository = notesRepository,
        super(
          EditNoteState(
            initialNote: initialNote,
            title: initialNote?.title ?? '',
            description: initialNote?.body ?? '',
          ),
        ) {
    on<EditNoteTitleChanged>(_onTitleChanged);
    on<EditNoteDescriptionChanged>(_onDescriptionChanged);
    on<EditNoteSubmitted>(_onSubmitted);
  }

  final NotesRepository _notesRepository;

  void _onTitleChanged(
    EditNoteTitleChanged event,
    Emitter<EditNoteState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditNoteDescriptionChanged event,
    Emitter<EditNoteState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    EditNoteSubmitted event,
    Emitter<EditNoteState> emit,
  ) async {
    emit(state.copyWith(status: EditNoteStatus.loading));
    final note = (state.initialNote ?? Note(title: '', body: '', imageUrl: '', noteTime: '', isArchived: false,)).copyWith(
      title: state.title,
      body: state.description,
    );

    try {
      await _notesRepository.saveNote(note);
      emit(state.copyWith(status: EditNoteStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditNoteStatus.failure));
    }
  }
}