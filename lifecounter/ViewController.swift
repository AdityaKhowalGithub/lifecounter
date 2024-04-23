//
//  ViewController.swift
//  lifecounter
//
//  Created by Aditya Khowal on 4/16/24.
//

import UIKit

class MyView: UIView {
    public let anotherView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .green
        
        clipsToBounds = true
//        anotherView.backgroundColor = .systemYellow
        anotherView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(anotherView)
        
        let topGuide = UILayoutGuide()
        let bottomGuide = UILayoutGuide()
        

        addLayoutGuide(topGuide)
        addLayoutGuide(bottomGuide)
        NSLayoutConstraint.activate([
            topGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            topGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            topGuide.topAnchor.constraint(equalTo: topAnchor),
            topGuide.heightAnchor.constraint(equalToConstant: 25),
            anotherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            anotherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            anotherView.topAnchor.constraint(equalTo: topGuide.bottomAnchor),
            anotherView.bottomAnchor.constraint(equalTo: bottomGuide.topAnchor),
            bottomGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomGuide.heightAnchor.constraint(equalToConstant: 25),
        ])
        }
    required init?(coder: NSCoder){
        fatalError()
    }
    

}

class ViewController: UIViewController {
    let myView = MyView()
    
    @IBOutlet weak var HistoryButton: UIButton!
    @IBOutlet weak var playerStackView: UIStackView!
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var playerStepper: UIStepper!
    @IBOutlet weak var PlayerStacks: UIStackView!
    @IBOutlet weak var WinnerLooser: UILabel!
    
    var gameStarted: Bool = false
    var players: [Player] = []
    var history: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Setup the stepper for player count adjustment
        configureStepper()

        // Update player count based on the stepper at start
        updatePlayerCount()

        // Set the background color of the main view
        view.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 220/255, alpha: 1) // #FDFCDC

        // Add myView to the main view controller's view
        view.addSubview(myView)
        
        
        

        // Configure myView's auto-layout constraints
        myView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // Initially hide the winner/loser label
        WinnerLooser.isHidden = true

        // Add PlayerStacks to myView's anotherView and set up constraints
        myView.anotherView.addSubview(PlayerStacks)
        PlayerStacks.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            PlayerStacks.centerXAnchor.constraint(equalTo: myView.anotherView.centerXAnchor),
            PlayerStacks.centerYAnchor.constraint(equalTo: myView.anotherView.centerYAnchor)
        ])
        playerStackView.spacing = 2
        
    }

    @IBAction func HistoryClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let historyViewController = storyboard.instantiateViewController(withIdentifier: "HistoryScreen") as! HistoryViewController
        
        self.present(historyViewController, animated: true, completion: nil)
        historyViewController.addHistory(history: history)
        
        
        
    }
    
//    
    
    private func configureStepper() {
        playerStepper.minimumValue = 2
        playerStepper.maximumValue = 8
        playerStepper.value = 4
        //Double(players.count)
        playerStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }

    @objc func stepperValueChanged(_ sender: UIStepper) {
        updatePlayerCount()
    }

    private func updatePlayerCount() {
        let count = Int(playerStepper.value)
        playerCountLabel.text = "Players: \(count)"

        if count > players.count {
            for _ in players.count..<count {
                addNewPlayer()
            }
        } else {
            for _ in count..<players.count {
                removeLastPlayer()
            }
        }
    }
    private func addNewPlayer() {
        var newPlayer = Player(lifeCount: 20)  // Initialize with default health
        let newPlayerView = createPlayerView(for: &newPlayer, index: players.count)
        players.append(newPlayer)
        playerStackView.addArrangedSubview(newPlayerView)
    }

    private func removeLastPlayer() {
        guard !players.isEmpty else { return }
        let lastPlayerView = playerStackView.arrangedSubviews.last
        playerStackView.removeArrangedSubview(lastPlayerView!)
        lastPlayerView?.removeFromSuperview()
        players.removeLast()
        // Update tags for all remaining buttons
        for (index, player) in players.enumerated() {
            player.healthButton?.tag = index
        }
    }

    func updateHealthBar(for index: Int) {
        guard index < players.count else { return }
        let player = players[index]
        let healthPercentage = Float(player.lifeCount) / 20.0 // Assuming max health is 20
        player.healthBar?.progress = healthPercentage
        player.healthButton?.setTitle("\(player.lifeCount)", for: .normal)
    }



    func createPlayerView(for player: inout Player, index: Int) -> UIStackView {
        let playerStack = UIStackView()
        playerStack.axis = .vertical
        playerStack.spacing = 2 // Reduced spacing
        playerStack.alignment = .fill
        playerStack.distribution = .fillProportionally

        // Player Name Label
        let playerNameLabel = UILabel()
        playerNameLabel.text = "Player \(index + 1)"
        playerNameLabel.font = UIFont(name: "Futura-Bold", size: 14)
        playerNameLabel.textAlignment = .center
        playerStack.addArrangedSubview(playerNameLabel)

        // Horizontal Stack View for health, text field, and plus/minus buttons
        let healthControlStack = UIStackView()
        healthControlStack.axis = .horizontal
        healthControlStack.spacing = 2
        healthControlStack.alignment = .center
        healthControlStack.distribution = .fillProportionally

        // Health Button
        let healthButton = UIButton()
        healthButton.setTitle("20", for: .normal)
        healthButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 16)
        healthButton.backgroundColor = UIColor.systemBlue
        healthButton.tintColor = UIColor.white
        healthButton.layer.cornerRadius = 5
        healthButton.tag = index
        player.healthButton = healthButton

        let healthTextField = UITextField()
        healthTextField.text = "5" // Set default text to "5"
        healthTextField.font = UIFont(name: "Futura", size: 14)
        healthTextField.borderStyle = .roundedRect
        healthTextField.textAlignment = .center
        healthTextField.keyboardType = .numberPad  // Set to number pad
        healthTextField.tag = index
        player.healthTextField = healthTextField


          // Plus Button
          let plusButton = UIButton(type: .system)  // Ensure using .system to get a button with visible title
          plusButton.setTitle("+", for: .normal)
          plusButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 16)
          plusButton.addTarget(self, action: #selector(adjustPlayerHealth(sender:)), for: .touchUpInside)
          plusButton.tag = index

          // Minus Button
          let minusButton = UIButton(type: .system)  // Ensure using .system to get a button with visible title
          minusButton.setTitle("-", for: .normal)
          minusButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 16)
          minusButton.addTarget(self, action: #selector(adjustPlayerHealth(sender:)), for: .touchUpInside)
          minusButton.tag = index

        healthControlStack.addArrangedSubview(healthButton)
        healthControlStack.addArrangedSubview(healthTextField)
        healthControlStack.addArrangedSubview(plusButton)
        healthControlStack.addArrangedSubview(minusButton)

        playerStack.addArrangedSubview(healthControlStack)

        // Health Progress Bar
        let healthBar = UIProgressView(progressViewStyle: .default)
        healthBar.progress = 1.0
        healthBar.tintColor = UIColor.green
        player.healthBar = healthBar

        playerStack.addArrangedSubview(healthBar)

        // Set constraints for the new elements
        healthButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        healthTextField.widthAnchor.constraint(equalToConstant: 60).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        minusButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        healthBar.heightAnchor.constraint(equalToConstant: 3).isActive = true

        return playerStack
    }

    @objc func adjustPlayerHealth(sender: UIButton) {
        let playerIndex = sender.tag
        guard playerIndex < players.count else { return }
        
        guard let adjustmentValueString = players[playerIndex].healthTextField?.text,
              let adjustmentValue = Int(adjustmentValueString),
              adjustmentValue != 0 else {
            // If the text field is empty, return or handle error as needed
            return
        }

        if sender.currentTitle == "+" {
            players[playerIndex].lifeCount += adjustmentValue
            history.append("Player \(playerIndex + 1) gained \(adjustmentValue) life.")
        } else if sender.currentTitle == "-" {
            players[playerIndex].lifeCount -= adjustmentValue
            history.append("Player \(playerIndex + 1) lost \(adjustmentValue) life.")
        }
        print(history)
        print(gameStarted)
        // Now disable the stepper to prevent adding new players
        if !gameStarted {
            gameStarted = true
            playerStepper.isEnabled = false
        }
        

        updateHealthBar(for: playerIndex)
    }


    
    @objc func playerHealthButtonPressed(_ sender: UIButton) {
        let playerIndex = sender.tag  // Retrieve the index from the tag

        // Perform any modifications needed, e.g., increment or decrement health
        // For demonstration, incrementing player's health by 1
        players[playerIndex].lifeCount += 1
        updateHealthBar(for: playerIndex)
    }


}
struct Player {
    var lifeCount: Int
    var healthBar: UIProgressView?
    var healthButton: UIButton?
    var healthTextField: UITextField?
}



