import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/home/data/models/child_header_model.dart';

class CaregiverChildrenCacheCubit
    extends HydratedCubit<List<ChildHeaderEntity>> {
  CaregiverChildrenCacheCubit() : super([]);

  void save(List<ChildHeaderEntity> children) {
    if (!isClosed) emit(children);
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
