//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import MarkupKit

class ViewController: UITableViewController, UICollectionViewDataSource {
    #if os(iOS)
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    @IBOutlet var sizeTextField: UITextField!
    @IBOutlet var sizePickerView: LMPickerView!
    #endif

    @IBOutlet var collectionView: LMCollectionView!

    #if os(iOS)
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var slider: UISlider!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var progressView: UIProgressView!
    #endif

    let icons = [
        "AccessTimeIcon",
        "BluetoothIcon",
        "CheckCircleIcon",
        "DoneIcon",
        "EventIcon",
        "FingerprintIcon",
        "GradeIcon"
    ]

    override func loadView() {
        view = LMViewBuilder.view(withName: "ViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Bundle.main.localizedString(forKey: "title", value: nil, table: nil)

        collectionView.dataSource = self
        
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.description())

        #if os(iOS)
        slider.minimumValue = Float(stepper.minimumValue)
        slider.maximumValue = Float(stepper.maximumValue)

        stepperValueChanged(stepper)
        #endif
    }

    @IBAction func showGreeting() {
        let alertController = UIAlertController(title: Bundle.main.localizedString(forKey: "greeting", value: nil, table: nil),
            message: Bundle.main.localizedString(forKey: "hello", value: nil, table: nil),
            preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: Bundle.main.localizedString(forKey: "ok", value: nil, table: nil),
            style: .default))

        present(alertController, animated: true)
    }

    #if os(iOS)
    @IBAction func cancelDateEdit() {
        dateTextField.resignFirstResponder()
    }

    @IBAction func updateDateText() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"

        dateTextField.text = dateFormatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
    }

    @IBAction func cancelSizeEdit() {
        sizeTextField.resignFirstResponder()
    }

    @IBAction func updateSizeText() {
        sizeTextField.text = sizePickerView.title(forRow: sizePickerView.selectedRow(inComponent: 0), forComponent: 0)!
        sizeTextField.resignFirstResponder()
    }
    #endif

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.description(), for: indexPath) as! IconCell

        #if os(tvOS)
        cell.label.text = String(indexPath.item)
        #endif

        cell.imageView.image = UIImage(named: icons[indexPath.item])

        return cell
    }

    #if os(iOS)
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        slider.value = Float(sender.value)

        updateState()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        stepper.value = Double(sender.value)

        updateState()
    }

    func updateState() {
        let value = slider.value

        pageControl.currentPage = Int(round(value * 10))
        progressView.progress = value
    }
    #endif
}
