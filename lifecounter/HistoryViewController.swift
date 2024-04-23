import UIKit

class HistoryViewController: UIViewController {
    var historyItems: [String] = []
    
    @IBOutlet weak var historyTextView: UITextView! // Connect this to your UITextView in the storyboard

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.text = historyItems.joined(separator: "\n")
    }
    
    // Add other methods as needed for your history display
}
