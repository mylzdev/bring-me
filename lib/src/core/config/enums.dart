/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

/// Switch of Custom Brand-Text-Size Widget
enum TextSizes { small, medium, large }

enum ContainerColor { pink, blue, yellow, green }

enum HuntLocation { outdoor, indoor }

enum ItemHuntStatus {
  initial,
  validationInProgress,
  validationSuccess,
  validationFailure
}

enum GameState { initial, progress, ended }
