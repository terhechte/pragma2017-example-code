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
    private var forms: [Form<State>] = []
    private var parentForm: Form<State>?

    public init(state: State, axis: UILayoutConstraintAxis = .vertical) {
        self.state = state
        view.axis = axis
    }

    public func apply(_ changes: (inout State)->Void) {
        let form = parentForm ?? self
        changes(&form.state)
        form.subscribers.forEach { subscriber in
            subscriber(form.state)
        }
    }

    public func add(_ cell: UIView, subscriber: @escaping (State)->Void) {
        let form = parentForm ?? self
        add(cell)
        form.subscribers.append(subscriber)
        subscriber(form.state)
    }

    public func add(_ cell: UIView) {
        view.addArrangedSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
    }

    public func addForm(axis: UILayoutConstraintAxis) -> Form<State> {
        let newForm = Form(state: self.state, axis: axis)
        newForm.parentForm = parentForm ?? self
        view.addArrangedSubview(newForm.view)
        forms.append(newForm)
        return newForm
    }
}

