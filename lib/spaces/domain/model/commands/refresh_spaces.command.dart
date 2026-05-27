import 'package:mobile/spaces/domain/model/valueobjects/space_id.valueobject.dart';

class RefreshSpacesCommand {
  final SpaceId? spaceId;

  const RefreshSpacesCommand({this.spaceId});
}
