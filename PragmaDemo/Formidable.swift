import Foundation

public final class Form<State, Event> {
    public typealias Reducer = (State, Event) -> State
    private var state: State
    private var subscribers: [(State)->Void] = []
    private var reducer: Reducer

    public init(state: State, reducer: @escaping Reducer) {
        self.state = state
        self.reducer = reducer
    }

    public func apply(_ event: Event) {
        state = reducer(state, event)
        subscribers.forEach { subscriber in
            subscriber(state)
        }
    }

    public func subscribe(_ subscriber: @escaping (State)->Void) {
        subscribers.append(subscriber)
        subscriber(state)
    }
}

