import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:notes_repository/note_repository.dart';

import '../../utils/text_utils.dart';

part 'edit_note_state.dart';

class EditNoteCubit extends Cubit<EditNoteState> {
  EditNoteCubit(this._notesRepository, Note note)
      : _note = note,
        super(const EditNoteState()) {
    TextUtils.printLog('note', note);
    emit(state.copyWith(initialNote: _note));
  }

  final NotesRepository _notesRepository;
  Note? _note;

  void onTitleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    onTitleChanged(value);
    return null;
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(body: value));
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    onDescriptionChanged(value);
    return null;
  }

  void onImageChanged(String value) {
    TextUtils.printLog('onImageChanged', value);
    emit(state.copyWith(imageUrl: value));
  }

  void onSaveNotePressed() async {
    TextUtils.printLog('onSaveNotePressed', ' add note pressed');
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
