import Foundation

struct Shortcut: Identifiable, Codable, Equatable {
    var id = UUID()
    var trigger: String
    var expansion: String
    var dateCreated: Date
    
    init(trigger: String, expansion: String) {
        self.trigger = trigger
        self.expansion = expansion
        self.dateCreated = Date()
    }
    
    static func ==(lhs: Shortcut, rhs: Shortcut) -> Bool {
        return lhs.id == rhs.id
    }
} 