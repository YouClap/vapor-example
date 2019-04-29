import Foundation

protocol Resource {}

protocol QueryResource {
    associatedtype Query
}

protocol ExternalResource {
    associatedtype External: Decodable
}

protocol DatabaseModel: Model {
    associatedtype Model: Encodable
}

protocol Model {
    var entity: String { get }
}

extension Model {
    var entity: String { return "\(type(of: self))" }
}
