import Vapor

struct User {
    var uid: UID
    var name: String
    var age: Int
    var gender: Gender
}

extension User {
    typealias UID = String

    enum Gender: String {
        case unspecified = "UNSPECIFIED"
        case undefined = "UNDEFINED"
        case male = "MALE"
        case female = "FEMALE"
    }
}

extension User {
    struct Create {
        var name: String
        var age: Int
        var gender: Gender
    }
}

extension User.Gender: Content {}

extension User.Create: Content {}

extension User: Content {}
