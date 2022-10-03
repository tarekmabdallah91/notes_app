import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_repository/note_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required NotesRepository notesRepository,
  })  : _notesRepository = notesRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final NotesRepository _notesRepository;

  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach<List<Note>>(
      _notesRepository.getNotes(),
      onData: (notes) => state.copyWith(
        status: StatsStatus.success,
        archivedNotes: notes.where((note) => note.isArchived).length,
        activeNotes: notes.where((note) => !note.isArchived).length,
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
