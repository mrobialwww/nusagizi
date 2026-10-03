import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/home/data/models/child_header_model.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_children_usecase.dart';

class ChildrenCacheCubit extends HydratedCubit<List<ChildHeaderEntity>> {
  final GetChildrenUseCase getChildrenUseCase;
  bool _isFetching = false;

  ChildrenCacheCubit({required this.getChildrenUseCase}) : super([]);

  void save(List<ChildHeaderEntity> children) {
    emit(children);
  }

  void remove(String childId) {
    emit(state.where((c) => c.id != childId).toList());
  }

  Future<void> fetchIfEmpty() async {
    if (state.isNotEmpty || _isFetching) return;
    _isFetching = true;

    try {
      final result = await getChildrenUseCase();
      result.fold((failure) {}, (children) {
        final cacheData = children
            .map(ChildHeaderModel.fromChildProfileEntity)
            .toList();
        emit(cacheData);
      });
    } finally {
      _isFetching = false;
    }
  }

  Future<void> refresh() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final result = await getChildrenUseCase();
      result.fold((failure) {}, (children) {
        final cacheData = children
            .map(ChildHeaderModel.fromChildProfileEntity)
            .toList();
        emit(cacheData);
      });
    } finally {
      _isFetching = false;
    }
  }

  @override
  List<ChildHeaderEntity>? fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('children')) {
        return (json['children'] as List)
            .map((e) => ChildHeaderModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}
    return null;
  }

  @override
  Map<String, dynamic>? toJson(List<ChildHeaderEntity> state) {
    return {
      'children': state
          .whereType<ChildHeaderModel>()
          .map((c) => c.toJson())
          .toList(),
    };
  }
}
