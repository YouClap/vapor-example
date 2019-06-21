import FluentMySQL
import Vapor

struct User: MySQLUUIDModel {
    var id: UUID?
    var name: String
    var age: Int
    var gender: Gender
}

extension User {
    enum Gender: String {
        case unspecified = "UNSPECIFIED"
        case undefined = "UNDEFINED"
        case male = "MALE"
        case female = "FEMALE"
    }
}

extension User.Gender: MySQLEnumType {
    static func reflectDecoded() throws -> (User.Gender, User.Gender) {
        return (.unspecified, .undefined)
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

extension User: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(User.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name)
            builder.field(for: \.age)
            builder.field(for: \.gender)
        }
    }
}

