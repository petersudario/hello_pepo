public struct ModelInfo {
  public let fileName: String
  public let displayName: String
  public let reference: String
  public let description: String
  public let soundFileName: String

  public init(fileName: String,
              displayName: String,
              reference: String,
              description: String,
              soundFileName: String) {
    self.fileName = fileName
    self.displayName = displayName
    self.reference = reference
    self.description = description
    self.soundFileName = soundFileName
  }
}
