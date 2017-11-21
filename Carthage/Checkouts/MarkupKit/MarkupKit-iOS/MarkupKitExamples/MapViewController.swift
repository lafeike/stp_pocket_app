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
import MapKit
import MarkupKit

class MapViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    
    let radius = 250.0
    
    override func loadView() {
        view = LMViewBuilder.view(withName: "MapViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Map View"

        edgesForExtendedLayout = UIRectEdge()

        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let defaultNotificationCenter = NotificationCenter.default

        defaultNotificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        defaultNotificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

        latitudeTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        showLocation()

        return false
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let layoutView = view as! LMLayoutView
        let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect

        layoutView.bottomSpacing = frame.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let layoutView = view as! LMLayoutView

        layoutView.bottomSpacing = 0
    }
    
    @IBAction func showLocation() {
        let latitude = (latitudeTextField.text == nil || latitudeTextField.text!.isEmpty) ? 0 : Double(latitudeTextField.text!)!
        let longitude = (longitudeTextField.text == nil || longitudeTextField.text!.isEmpty) ? 0 : Double(longitudeTextField.text!)!
        
        if (latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180) {
            let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius * 1000, radius * 1000)

            if (region.center.latitude + region.span.latitudeDelta <= 90
                && region.center.latitude - region.span.latitudeDelta >= -90) {
                mapView.setRegion(region, animated: true)
            }
        }
    }
}
