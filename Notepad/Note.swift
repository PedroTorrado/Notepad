import Foundation

struct Note: Identifiable, Hashable, Codable {
    var id: UUID
    var title: String
    var body: String

    // Custom initializer to create a new note
    init(title: String, body: String) {
        self.id = UUID()
        self.title = title
        self.body = body
    }
    
    // Explicit Codable implementation to ensure keys are handled correctly
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
    }
    
    // Custom decoder initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body)
    }

    // Custom encoder method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }
}
