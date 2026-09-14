import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_entity.dart';
import 'package:nusagizi/features/mother/profile/domain/usecases/get_child_detail_usecase.dart';
import 'add_edit_profile_state.dart';

class AddEditProfileCubit extends Cubit<AddEditProfileState> {
  final GetChildDetailUseCase getChildDetailUseCase;

  AddEditProfileCubit({required this.getChildDetailUseCase})
    : super(const AddEditProfileState());

  bool get hasGrowthData => state.weightKg != null && state.heightCm != null;

  void initialize(ChildEntity child) {
    final parts = child.birthDate.split('-');
    final birthDate = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
    emit(
      state.copyWith(
        fullName: child.fullName,
        birthDate: birthDate,
        gender: child.gender,
        photoUrl: child.photoUrl,
        allergies: child.allergies,
        chronicDiseases: child.chronicDiseases,
        diets: child.diets,
        favoriteFoods: child.favoriteFoods,
        favoriteTextures: child.favoriteTextures,
        notes: child.notes,
        isLoading: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> loadChildDetail(String childId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getChildDetailUseCase(childId);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (child) => initialize(child),
    );
  }

  void updateStep1({
    required String fullName,
    required DateTime? birthDate,
    required String gender,
    String? photoUrl,
    double? weightKg,
    double? heightCm,
    double? headCircumferenceCm,
  }) {
    emit(
      state.copyWith(
        fullName: fullName,
        birthDate: birthDate,
        gender: gender,
        photoUrl: photoUrl,
        weightKg: weightKg,
        heightCm: heightCm,
        headCircumferenceCm: headCircumferenceCm,
      ),
    );
  }

  void updateStep2({
    required Map<String, List<String>> allergies,
    required List<String> chronicDiseases,
    required List<String> diets,
  }) {
    emit(
      state.copyWith(
        allergies: allergies,
        chronicDiseases: chronicDiseases,
        diets: diets,
      ),
    );
  }

  void updateStep3({
    required List<String> favoriteFoods,
    required List<String> favoriteTextures,
    String? notes,
  }) {
    emit(
      state.copyWith(
        favoriteFoods: favoriteFoods,
        favoriteTextures: favoriteTextures,
        notes: notes,
      ),
    );
  }
}
