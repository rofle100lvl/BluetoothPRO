import Foundation

struct AddToFriendQuery: Codable {
    let first_id: UUID
    let second_id: UUID
    
    var dictionary: [String: Any] {
        return ["first_id": first_id,
                "second_id": second_id]
    }
}
