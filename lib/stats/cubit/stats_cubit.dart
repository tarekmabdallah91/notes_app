import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_repository/note_repository.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit({
    required NotesRepository notesRepository,
  })  : _notesRepository = notesRepository,
        super(const StatsState()) {
    _onSubscriptionRequested();
  }

  final NotesRepository _notesRepository;

  void _onSubscriptionRequested() {
    emit(state.copyWith(status: StatsStatus.loading));

    _notesRepository.getNotes().listen(
          (notes) => emit(state.copyWith(
            status: StatsStatus.success,
            archivedNotes: notes.where((note) => note.isArchived).length,
            activeNotes: notes.where((note) => !note.isArchived).length,
          )),
          onError: (_, __) => state.copyWith(status: StatsStatus.failure),
        );
  }
}
