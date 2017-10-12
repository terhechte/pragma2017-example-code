import UIKit

struct Cinnamon {
    var amount: Int
    var name: String
}

enum Event {
    case increaseAmount
}

func eventReducer(state: Cinnamon, event: Event) -> Cinnamon {
    var newState = state
    switch event {
    case .increaseAmount: newState.amount += 10
    }
    return newState
}

class ViewController: UIViewController {

    let form = Form(state: Cinnamon(amount: 0, name: "Ceylon"),
                    reducer: eventReducer)

    override func viewDidLoad() {
        super.viewDidLoad()
        form.subscribe { (state) in
            print("\(state.amount) of \(state.name)")
        }

        let button = UIButton(type: .roundedRect)
        button.setTitle("Click me", for: .normal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc func didTapButton(sender: UIButton) {
        form.apply(.increaseAmount)
    }
}

