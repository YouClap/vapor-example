import Vapor

final class HTTPController: RouterController {

//    private let businessLogic:
//
//    init(businessLogic) {
//        self.businessLogic = businessLogic
//    }

    func boot(router: Router) throws {
        let users = router.grouped("user")

        users.get("/", User.UID.parameter, use: index)
        users.post(User.Create.self, at: "/", use: create)
        users.delete("/", User.UID.parameter, use: delete)
    }

    // MARK: - CRUD Methods

    private func index(_ request: Request) throws -> Future<User> {
        let uid = try userID(from: request)

        return request.future(User(uid: uid, name: "a", age: 1, gender: .undefined))
    }

    private func create(_ request: Request, user: User.Create) throws -> Future<Response> {
        return User(uid: UUID().uuidString, name: user.name, age: user.age, gender: user.gender)
            .encode(status: .created, for: request)
    }

    private func delete(_ request: Request) throws -> Future<HTTPStatus> {
        let uid = try userID(from: request)

        print("deleting user with UID \(uid) 👋")

        // TODO: Check for userID in the database
        return request.future(.ok)
    }

    // MARK: - Private Methods

    private func userID(from request: Request) throws -> User.UID {
        guard let userID = try? request.parameters.next(User.UID.self) else {
            throw Abort(.notFound)
        }

        return userID
    }
}
