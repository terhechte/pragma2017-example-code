import Foundation

public final class Form<State> {
    private var state: State
    private var subscribers: [(State)->Void] = []

    public init(state: State) {
        self.state = state
    }

    public func apply(_ changes: (inout State)->Void) {
        changes(&state)
        subscribers.forEach { subscriber in
            subscriber(state)
        }
    }

    public func subscribe(_ subscriber: @escaping (State)->Void) {
        subscribers.append(subscriber)
        subscriber(state)
    }
}
