import UIKit

struct CinnamonCalculator {
    enum CinnamonType: Int { case cassia, ceylon }
    var type: CinnamonType
    var amount: Float
}

class ViewController: UIViewController {

    let formBuilder = Form(state: CinnamonCalculator(type: .cassia, amount: 1))

    override func viewDidLoad() {
        super.viewDidLoad()

        let cinnamonSelector = UISegmentedControl(items: ["Cassia", "Ceylon"])
        cinnamonSelector.addTarget(self, action: #selector(self.didChangeCinnamonType(sender:)), for: .valueChanged)
        formBuilder.add(cinnamonSelector) { (state) in
            cinnamonSelector.selectedSegmentIndex = state.type.rawValue
        }

        do {
            let parentForm = formBuilder.addForm(axis: .horizontal)
            let cinnamonSlider = UISlider()
            cinnamonSlider.minimumValue = 0.0
            cinnamonSlider.maximumValue = 200.0
            cinnamonSlider.widthAnchor.constraint(equalToConstant: 150).isActive = true
            cinnamonSlider.addTarget(self, action: #selector(self.didChangeCinnamonSlider(sender:)), for: .valueChanged)
            parentForm.add(cinnamonSlider) { (state) in
                cinnamonSlider.value = state.amount
            }

            let cinnamonValue = UITextField()
            let formatter = NumberFormatter()
            formatter.positiveFormat = "###0g"
            cinnamonValue.widthAnchor.constraint(equalToConstant: 50).isActive = true
            parentForm.add(cinnamonValue) { (state) in
                cinnamonValue.text = formatter.string(from: NSNumber(value: state.amount))
            }
        }

        let warning = UITextField()
        formBuilder.add(warning) { (state) in
            let tuple: (String, UIColor, Bool)
            switch (state.type, state.amount) {
            case (.cassia, 25...50):
                tuple = ("Unsafe", .orange, false)
            case (.cassia, 50...199):
                tuple = ("Toxic", .red, false)
            case (.cassia, 199...200):
                tuple = ("You're Dead", .red, false)
            case (.ceylon, 100...199):
                tuple = ("Unsafe", .orange, false)
            case (.ceylon, 199...200):
                tuple = ("Toxic", .orange, false)
            default:
                tuple = ("", .black, true)
            }
            warning.isHidden = tuple.2
            warning.textColor = tuple.1
            warning.text = tuple.0
        }

        let resetButton = UIButton(type: .roundedRect)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(self.didReset(sender:)), for: .touchUpInside)
        formBuilder.add(resetButton)

        view.addSubview(formBuilder.view)
        formBuilder.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        formBuilder.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc func didChangeCinnamonType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: formBuilder.apply({ $0.type = .ceylon })
        default: formBuilder.apply({ $0.type = .cassia })
        }
    }

    @objc func didChangeCinnamonSlider(sender: UISlider) {
        formBuilder.apply({ $0.amount = sender.value })
    }

    @objc func didReset(sender: UIButton) {
        formBuilder.apply { (state) in
            state.amount = 1
            state.type = .cassia
        }
    }

}

