import protocol Vapor.Service
import ReactiveSwift

protocol UserServiceRepresentable: Vapor.Service {
    func create(user: User.Create) -> SignalProducer<User, UserService.Error>
    func user(with userUID: User.ID) -> SignalProducer<User, UserService.Error>
    func delete(user userUID: User.ID) -> SignalProducer<User, UserService.Error>
}
