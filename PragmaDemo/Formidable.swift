import UIKit

public final class Form<State> {

    public let view: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

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

    public func add(_ cell: UIView, subscriber: @escaping (State)->Void) {
        add(cell)
        subscribers.append(subscriber)
        subscriber(state)
    }

    public func add(_ cell: UIView) {
        view.addArrangedSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
    }
}
