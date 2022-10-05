import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';
import 'package:remote_storage_notes_api/remote_storage_notes_api.dart';

part 'edit_note_event.dart';
part 'edit_note_state.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  EditNoteBloc({
    required NotesRepository notesRepository,
    required RemoteRepository remoteRepository,
    Note? initialNote,
  })  : _notesRepository = notesRepository,
        _remoteRepository = remoteRepository,
        super(
          EditNoteState(
            initialNote: initialNote,
            title: initialNote?.title ?? '',
            body: initialNote?.body ?? '',
            imageUrl: initialNote?.imageUrl ?? '',
          ),
        ) {
    on<EditNoteTitleChanged>(_onTitleChanged);
    on<EditNoteDescriptionChanged>(_onDescriptionChanged);
    on<EditNoteImageChanged>(_onImageChanged);
    on<EditNoteSubmitted>(_onSubmitted);
  }

  final NotesRepository _notesRepository;
  final RemoteRepository _remoteRepository;

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
    emit(state.copyWith(body: event.description));
  }

  void _onImageChanged(
    EditNoteImageChanged event,
    Emitter<EditNoteState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
  }

  Future<void> _onSubmitted(
    EditNoteSubmitted event,
    Emitter<EditNoteState> emit,
  ) async {
    emit(state.copyWith(status: EditNoteStatus.loading));
    final note = (state.initialNote ?? Note.initialNote()).copyWith(
      title: state.title,
      body: state.body,
      imageUrl: state.imageUrl,
      noteTime: DateTime.now().toString(),
    );
    try {
      TextUtils.printLog('_onSubmitted', note.toString());
      await _notesRepository.saveNote(note);
      emit(state.copyWith(status: EditNoteStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditNoteStatus.failure));
    }
  }
}
