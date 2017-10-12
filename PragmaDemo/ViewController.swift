import UIKit

struct Cinnamon {
    var amount: Int
    var name: String
}

class ViewController: UIViewController {

    let form = Form(state: Cinnamon(amount: 0, name: "Ceylon"))

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
        form.apply { $0.amount += 10 }
    }
}

