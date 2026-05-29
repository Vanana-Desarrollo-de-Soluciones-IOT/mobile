import 'package:mobile/spaces/domain/model/valueobjects/space_id.valueobject.dart';
import 'package:mobile/spaces/domain/model/valueobjects/space_name.valueobject.dart';

class UpdateSpaceNameCommand {
  final SpaceId spaceId;
  final SpaceName name;

  const UpdateSpaceNameCommand({
    required this.spaceId,
    required this.name,
  });
}
