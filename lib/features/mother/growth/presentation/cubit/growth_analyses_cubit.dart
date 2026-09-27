import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/growth/domain/entities/growth_analyses_entity.dart';
import 'package:nusagizi/features/mother/growth/domain/usecases/get_growth_analyses_usecase.dart';
import 'growth_analyses_state.dart';

class GrowthAnalysesCubit extends Cubit<GrowthAnalysesState> {
  final GetGrowthAnalysesUseCase _useCase;

  // Cache in-memory: hidup selama Cubit hidup (selama GrowthPage terbuka)
  // Key format: "weight_for_age__0-60"
  final Map<String, GrowthAnalysesEntity> _cache = {};

  GrowthAnalysesCubit(this._useCase) : super(GrowthAnalysesInitial());

  Future<void> fetch({
    required String childId,
    required String analysisType,
    required String ageRange,
  }) async {
    final key = '${analysisType}__$ageRange';

    // Cache hit — emit langsung tanpa panggil API
    if (_cache.containsKey(key)) {
      emit(GrowthAnalysesLoaded(_cache[key]!));
      return;
    }

    emit(GrowthAnalysesLoading());

    final result = await _useCase(
      GrowthAnalysesParams(
        childId: childId,
        analysisType: analysisType,
        ageRange: ageRange,
      ),
    );

    result.fold((failure) => emit(GrowthAnalysesError(failure.message)), (
      data,
    ) {
      _cache[key] = data; // Simpan ke cache
      emit(GrowthAnalysesLoaded(data));
    });
  }

  /// Hapus semua cache agar fetch() berikutnya selalu mengambil data terbaru dari API.
  /// Gunakan ini setelah operasi CRUD (tambah/edit data pertumbuhan).
  void invalidateCache() => _cache.clear();
}
