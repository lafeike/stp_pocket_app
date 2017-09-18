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

class PageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var pageView: LMPageView!
    @IBOutlet var pageControl: UIPageControl!

    override func loadView() {
        view = LMViewBuilder.view(withName: "PageViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Page View"

        edgesForExtendedLayout = UIRectEdge()

        pageView.delegate = self

        pageControl.numberOfPages = pageView.pages.count
    }

    func updatePage() {
        pageView.setCurrentPage(pageControl.currentPage, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.currentPage
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.currentPage
    }
}

