import ReactiveSwift

protocol ServiceRepresentable {
    func create(user: User.Create) -> SignalProducer<User, Service.Error>
    func user(with userUID: User.UID) -> SignalProducer<User, Service.Error>
    func delete(user userUID: User.UID) -> SignalProducer<Void, Service.Error>
}
