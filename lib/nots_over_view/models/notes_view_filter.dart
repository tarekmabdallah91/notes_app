

import 'package:notes_api/notes_api.dart';

enum NotesViewFilter { all, activeOnly, completedOnly }

extension NotesViewFilterX on NotesViewFilter {
  bool apply(Note note) {
    switch (this) {
      case NotesViewFilter.all:
        return true;
      case NotesViewFilter.activeOnly:
        return !note.isArchived;
      case NotesViewFilter.completedOnly:
        return note.isArchived;
    }
  }

  Iterable<Note> applyAll(Iterable<Note> notes) {
    return notes.where(apply);
  }
}
