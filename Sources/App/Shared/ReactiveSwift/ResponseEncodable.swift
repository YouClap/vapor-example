import ReactiveSwift
import Vapor

extension SignalProducer: ResponseEncodable where Value: ResponseEncodable, Error: Debuggable {
    public func encode(for req: Request) throws -> Future<Response> {
        let responsePromise = req.eventLoop.newPromise(of: Response.self)

        startWithResult {
            do {
                switch $0 {
                case .success(let value):
                    let futureValue = try value.encode(for: req)

                    futureValue.whenSuccess { responsePromise.succeed(result: $0) }
                    futureValue.whenFailure { responsePromise.fail(error: $0) }
                case .failure(let error): responsePromise.fail(error: error)
                }
            } catch {
                responsePromise.fail(error: error)
            }
        }

        return responsePromise.futureResult
    }
}
