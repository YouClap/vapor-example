import FluentMySQL
import ReactiveSwift
import Vapor

final class MySQLDatabaseConnectable: DatabaseConnectable, ContainerAlias {
    private let eventLoopGroup: EventLoopGroup

    static var aliasedContainer: KeyPath<MySQLDatabaseConnectable, Container> = \.container

    private let container: Container

    init(container: Container) {
        self.container = container
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    }

    func next() -> EventLoop {
        return eventLoopGroup.eventLoop
    }

    func databaseConnection<D>(to database: DatabaseIdentifier<D>?) -> Future<D.Connection> {
        guard let database = database else {
            let error = VaporError(
                identifier: "defaultDB",
                reason: "`Model.defaultDatabase` is required to use request as `DatabaseConnectable`.",
                suggestedFixes: [
                    "Ensure you are using the 'model' label when registering this model to your migration config (if it is a migration): migrations.add(model: ..., database: ...).",
                    "If the model you are using is not a migration, set the static `defaultDatabase` property manually in your app's configuration section.",
                    "Use `req.withPooledConnection(to: ...) { ... }` instead."
                ]
            )
            return eventLoopGroup.eventLoop.newFailedFuture(error: error)
        }

        return container.requestCachedConnection(to: database)
    }
}
