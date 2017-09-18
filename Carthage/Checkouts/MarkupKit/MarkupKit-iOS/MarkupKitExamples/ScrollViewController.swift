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

class ScrollViewController: UIViewController {
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!

    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)

    override func loadView() {
        view = LMViewBuilder.view(withName: "ScrollViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Scroll View"

        edgesForExtendedLayout = UIRectEdge()
        
        let textPath = Bundle.main.path(forResource: "sample", ofType: "txt")
        let text = try? String(contentsOfFile: textPath!, encoding: String.Encoding.ascii)

        label1.text = text
        label2.text = text
    }

    @IBAction func showGreeting() {
        let alertController = UIAlertController(title: "Greeting", message: "Hello!", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))

        present(alertController, animated: true)
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        dispatchQueue.async {
            Thread.sleep(forTimeInterval: 2)

            OperationQueue.main.addOperation() {
                sender.endRefreshing()
            }
        }
    }
}
