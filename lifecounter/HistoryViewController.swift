import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyStack: UIStackView!
    var historyData: [String] = [] // Array to store history data

    override func viewDidLoad() {
        super.viewDidLoad()
        historyStack.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               historyStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
               historyStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
               historyStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
               historyStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
           ])
        
       }
    
    func addHistory(history: [String]) {
        print("addHistory called with \(history.count) items")
        
        for (index, item) in history.enumerated() {
            print("Processing item \(index): \(item)")
            
            if let historyStack = historyStack {
                let containerView = UIView()
                containerView.backgroundColor = .clear
                
                let label = UILabel()
                label.text = item
                label.font = UIFont(name: "Helvetica Neue", size: 20)
                label.textColor = .black
                label.numberOfLines = 0
                
                containerView.addSubview(label)
                
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                    label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                    label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                    label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
                ])
                
                historyStack.addArrangedSubview(containerView)
            } else {
                print("historyStack is nil")
            }
        }
    }
//    func addHistory(history: [String]) {
//        for item in history {
//            if let historyStack = historyStack {
//                let label = UILabel()
//                label.text = item
//                label.font = UIFont(name: "Helvetica Neue", size: 20)
//                label.textColor = UIColor.black
//                label.numberOfLines = 0
//                
//                historyStack.addArrangedSubview(label)
//            }
//        }
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("historyStack frame: \(historyStack.frame)")
        
        for label in historyStack.arrangedSubviews {
            if let label = label as? UILabel {
                print("Label frame: \(label.frame)")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
