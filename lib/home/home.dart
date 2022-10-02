export '../cubit/note_cubit.dart';
export './view/view.dart';


// ├── HomePage
// │   └── BlocProvider<HomeCubit>
// │       └── HomeView
// │           ├── context.select<HomeCubit, HomeTab>
// │           └── BottomAppBar
// │               └── HomeTabButton(s)
// │                   └── context.read<HomeCubit>