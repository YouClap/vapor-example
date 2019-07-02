import Fluent
import FluentMySQL
import Vapor
import ReactiveSwift

final class HTTPController: RouterController {

    private let service: UserServiceRepresentable

    init(service: UserServiceRepresentable) {
        self.service = service
    }

    func boot(router: Router) throws {
        let users = router.grouped("user")

        users.get("/", User.ID.parameter, use: index)
        users.post(User.Create.self, at: "/", use: create)
        users.delete("/", User.ID.parameter, use: delete)
    }

    // MARK: - CRUD Methods

    // NOTE: We can return a SignalProducer, but perhaps we could return a Future
    // to have a uniform API
    private func index(_ request: Request) throws -> Future<Response> {
        let uid = try userID(from: request)

        return try service.user(with: uid)
            .mapError(Error.service)
            .encode(for: request)
    }

    private func create(_ request: Request, user: User.Create) throws -> Future<Response> {
        return service.create(user: user)
            .mapError(Error.service)
            .encode(status: .created, for: request)
    }

    private func delete(_ request: Request) throws -> Future<Response> {
        let uid = try userID(from: request)

        return try service.delete(user: uid)
            .mapError(Error.service)
            .map { _ in HTTPStatus.ok }
            .encode(for: request)

//        return try service.delete(user: uid)
//            .map { _ in HTTPStatus.ok }
//            .mapError(Error.service)
//            .encode(for: request)
    }

    // MARK: - Private Methods

    private func userID(from request: Request) throws -> User.ID {
        guard let userID = try? request.parameters.next(User.ID.self) else {
            throw Abort(.notFound)
        }

        return userID
    }
}

extension HTTPController {
    enum Error: Swift.Error {
        case service(UserService.Error)
    }
}

// MARK: - Debuggable

// TODO: Improve error representation to provide more information
extension UserService.Error: Debuggable {
    var identifier: String {
        switch self {
        case .missingUser: return "MISSING_USER"
        case .store: return "STORE"
        }
    }

    var reason: String {
        switch self {
        case .missingUser(let userID):
            return "user \(userID) not found"
        case .store(let error): return error.localizedDescription
        }
    }
}

extension HTTPController.Error: Debuggable {
    var identifier: String {
        switch self {
        case .service(let serviceError): return serviceError.identifier
        }
    }

    var reason: String {
        switch self {
        case .service(let serviceError): return serviceError.reason
        }
    }
}
