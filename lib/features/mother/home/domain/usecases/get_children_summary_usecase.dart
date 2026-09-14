import 'package:dartz/dartz.dart';
import 'package:nusagizi/core/error/failures.dart';
import 'package:nusagizi/core/usecase/usecase.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';
import 'package:nusagizi/features/mother/home/domain/repositories/mother_home_repository.dart';

class GetChildrenSummaryUseCase implements UseCaseNoParams<List<ChildSummaryEntity>> {
  final MotherHomeRepository repository;

  GetChildrenSummaryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ChildSummaryEntity>>> call() async {
    final result = await repository.getChildrenSummary();
    
    return result.map((children) {
      return children.map((child) {
        return child.copyWith(
          dailyFocuses: [
            'Berikan makan siang sesuai rekomendasi',
            'Upload foto makan siang',
            'Lakukan stimulasi motorik halus selama 10 menit',
          ],
        );
      }).toList();
    });
  }
}
