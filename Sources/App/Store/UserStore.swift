import FluentMySQL
import ReactiveSwift
import Vapor

final class UserStore: UserStoreRepresentable {
    typealias M = User

    let databaseConnectable: MySQLDatabaseConnectable

    init(databaseConnectable: MySQLDatabaseConnectable) {
        self.databaseConnectable = databaseConnectable
    }
}
