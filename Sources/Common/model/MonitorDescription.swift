public enum MonitorDescription: Equatable, Sendable {
    case sequenceNumber(Int)
    case main
    case secondary
    case builtIn
    case external
    case nonMainExternal
    case pattern(CaseInsensitiveRegex)

    public static func pattern(_ raw: String) -> MonitorDescription? {
        switch CaseInsensitiveRegex.new(raw) {
            case .success(let regex): .pattern(regex)
            case .failure: nil
        }
    }
}

public func parseMonitorDescription(_ raw: String) -> ResOrStr<MonitorDescription> {
    if let int = Int(raw) {
        return int >= 1
            ? .success(.sequenceNumber(int))
            : .failure("Monitor sequence numbers uses 1-based indexing. Values less than 1 are illegal")
    }
    switch raw {
        case "main": return .success(.main)
        case "secondary": return .success(.secondary)
        case "built-in": return .success(.builtIn)
        case "external": return .success(.external)
        case "non-main-external": return .success(.nonMainExternal)
        default: break
    }

    return raw.isEmpty
        ? .failure("Empty string is an illegal monitor description")
        : CaseInsensitiveRegex.new(raw).map(MonitorDescription.pattern)
}
