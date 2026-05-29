import 'package:mobile/spaces/domain/model/valueobjects/space_id.valueobject.dart';

class DeleteSpaceCommand {
  final SpaceId spaceId;

  const DeleteSpaceCommand({required this.spaceId});
}
