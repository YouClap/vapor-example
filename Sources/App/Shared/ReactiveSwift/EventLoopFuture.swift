import ReactiveSwift
import NIO

extension EventLoopFuture {
    var reactive: SignalProducer<T, Error> {
        return SignalProducer { observer, _ in
            self.whenSuccess {
                observer.send(value: $0)
                observer.sendCompleted()
            }

            self.whenFailure { observer.send(error: $0) }
        }
    }
}
