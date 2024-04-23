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
    
        
    
    
    @IBOutlet weak var playerStackView: UIStackView!
    @IBOutlet weak var Label1: UILabel!
   
    @IBOutlet weak var playerCountLabel: UILabel!
    
    @IBOutlet weak var playerStepper: UIStepper!
    @IBOutlet weak var Player1Stack: UIStackView!
    
    
    
    @IBOutlet weak var PlayerStacks: UIStackView!
    

    @IBOutlet weak var Player1Health: UIButton!
    
    @IBOutlet weak var Player1Healt: UIStackView!
    @IBOutlet weak var Player2Health: UIButton!
    
    @IBOutlet weak var Player2HealthBar: UIProgressView!
    @IBOutlet weak var Player1Plus5: UIButton!
    
    @IBOutlet weak var Player1HealthBar: UIProgressView!
    @IBOutlet weak var Player1Plus1: UIButton!
    
    @IBOutlet weak var Player1Minus1: UIButton!
    
    @IBOutlet weak var Player1Minus5: UIButton!
    
    @IBOutlet weak var Player2Plus5: UIButton!
    
    @IBOutlet weak var Player2Plus1: UIButton!
    
    @IBOutlet weak var Player2Minus1: UIButton!
    
    @IBOutlet weak var Player2Minus5: UIButton!
    
    @IBOutlet weak var WinnerLooser: UILabel!
    
    @IBOutlet weak var VariableChangeP: UITextField!
    
    @IBOutlet weak var PlayerPLus: UIButton!
    
    @IBOutlet weak var PlayerMinus: UIButton!
    
    
    var players: [Player] = []
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

//    private func addNewPlayer() {
//        let newPlayer = Player(lifeCount: 20) // Initialize with default health
//        players.append(newPlayer)
//        let newPlayerView = createPlayerView(for: newPlayer)
//        playerStackView.addArrangedSubview(newPlayerView)
//    }
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

    @IBAction func modifyPlayerHealth(sender: UIButton) {
        // Identify player associated with the button
        // This can be done by comparing sender with player.healthButton or using tags
        let playerIndex = sender.tag // assuming you set tags when creating players
        let modification = Int(VariableChangeP.text ?? "0") ?? 0

        players[playerIndex].lifeCount += modification // adjust according to the button pressed (+/-)
        updateHealthBar(for: playerIndex)
    }

    func updateHealthBar(for index: Int) {
        guard index < players.count else { return }
        let player = players[index]
        let healthPercentage = Float(player.lifeCount) / 20.0  // Assuming max health is 20
        player.healthBar?.progress = healthPercentage
        player.healthButton?.setTitle("\(player.lifeCount)", for: .normal)
    }


    func createPlayerView(for player: inout Player, index: Int) -> UIStackView {
        let playerStack = UIStackView()
        playerStack.axis = .vertical
        playerStack.spacing = 5  // Reduced spacing
        playerStack.distribution = .fillEqually
        playerStack.alignment = .fill
        playerStack.translatesAutoresizingMaskIntoConstraints = false

        // Player Name Label
        let playerNameLabel = UILabel()
        playerNameLabel.text = "Player \(index + 1)"
        playerNameLabel.textAlignment = .center
        playerNameLabel.font = UIFont(name: "Futura-Bold", size: 20) // Smaller font size
        playerNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true // Smaller label height
        playerStack.addArrangedSubview(playerNameLabel)

        // Health Button
        let healthButton = UIButton(type: .system)
        healthButton.setTitle("20", for: .normal)
        healthButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 18) // Smaller font size
        healthButton.backgroundColor = UIColor.systemBlue
        healthButton.tintColor = UIColor.white
        healthButton.layer.cornerRadius = 5
        healthButton.translatesAutoresizingMaskIntoConstraints = false
        healthButton.heightAnchor.constraint(equalToConstant: 40).isActive = true  // Smaller button height
        healthButton.widthAnchor.constraint(equalToConstant: 120).isActive = true  // Smaller button width
        healthButton.tag = index
        healthButton.addTarget(self, action: #selector(playerHealthButtonPressed(_:)), for: .touchUpInside)
        playerStack.addArrangedSubview(healthButton)
        player.healthButton = healthButton

        // Health Progress Bar
        let healthBar = UIProgressView(progressViewStyle: .default)
        healthBar.progress = 1.0
        healthBar.tintColor = UIColor.green
        healthBar.translatesAutoresizingMaskIntoConstraints = false
        healthBar.heightAnchor.constraint(equalToConstant: 5).isActive = true  // Thinner progress bar
        playerStack.addArrangedSubview(healthBar)
        healthBar.widthAnchor.constraint(equalTo: healthButton.widthAnchor).isActive = true // Match width with the button
        player.healthBar = healthBar

        return playerStack
    }

    
    @objc func playerHealthButtonPressed(_ sender: UIButton) {
        let playerIndex = sender.tag  // Retrieve the index from the tag

        // Perform any modifications needed, e.g., increment or decrement health
        // For demonstration, incrementing player's health by 1
        players[playerIndex].lifeCount += 1
        updateHealthBar(for: playerIndex)
    }



//    func createPlayerView(for player: Player) -> UIStackView {
//        let playerStack = UIStackView()
//        playerStack.axis = .vertical
//        playerStack.distribution = .fillEqually
//        playerStack.alignment = .fill
//        playerStack.spacing = 10
//        playerStack.translatesAutoresizingMaskIntoConstraints = false
//
//        // Player Label
//        let playerNameLabel = UILabel()
//        playerNameLabel.text = "Player"
//        playerNameLabel.textAlignment = .center
//        playerNameLabel.font = UIFont(name: "Futura-Bold", size: 34)
//        playerStack.addArrangedSubview(playerNameLabel)
//
//        // Health Button
//        let healthButton = UIButton(type: .system)
//        healthButton.setTitle("20", for: .normal)
//        healthButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 30)
//        healthButton.backgroundColor = UIColor.systemBlue
//        healthButton.tintColor = UIColor.white
//        healthButton.layer.cornerRadius = 5
//        player.healthButton = healthButton
//        playerStack.addArrangedSubview(healthButton)
//
//        // Health Progress Bar
//        let healthBar = UIProgressView(progressViewStyle: .default)
//        healthBar.progress = 1.0 // start with full health
//        healthBar.tintColor = UIColor.green
//        player.healthBar = healthBar
//        playerStack.addArrangedSubview(healthBar)
//
//        // Setup constraints for stack view
//        playerNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        healthButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        healthBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
//
//        return playerStack
//    }

    // Implement game logic functions that iterate over `players`
    // Example: func updateHealthBars() { ... }
}

struct Player {
    var lifeCount: Int
    var healthBar: UIProgressView?
    var healthButton: UIButton?
}


//
//    var player1Life = 20
//    var player2Life = 20
//    
//    func getAT(s: Int) -> NSAttributedString {
//        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Futura-Bold", size: 30.0)!]
//        return NSAttributedString(string: "\(s)", attributes: attributes)
//    }
//    func updateHealthBars() {
//        Player1Health.isUserInteractionEnabled = false
//        Player2Health.isUserInteractionEnabled = false
//        Player1Health.setAttributedTitle(getAT(s: player1Life), for: .normal)
//        Player2Health.setAttributedTitle(getAT(s: player2Life), for: .normal)
//        Player1HealthBar.progress = Float(player1Life) / 20.0
//        Player2HealthBar.progress = Float(player2Life) / 20.0
//    }
//    func checkForWinner() {
//        if player1Life <= 0 {
//            WinnerLooser.text = "Player 1 LOSES!"
//            WinnerLooser.isHidden = false
//        } else if player2Life <= 0 {
//            WinnerLooser.text = "Player 2 LOSES!"
//            WinnerLooser.isHidden = false
//        }
//    }
//    
//    @IBAction func Player1Plus5(_ sender: Any) {
//        // Safely convert the text to an integer. If conversion fails, default to adding 0.
//        print(VariableChangeP.text ?? "pp")
//        if let changeAmount = Int(VariableChangeP.text ?? "0") {
//            player1Life += changeAmount
//        } else {
//            print("Invalid input: \(VariableChangeP.text ?? "nil")")
//        }
//        updateHealthBars()
//        checkForWinner()
//    }
//    
//    @IBAction func Player1Plus1(_ sender: Any) {
//        player1Life += 1
//        updateHealthBars()
//        checkForWinner()
//    }
//    
//    @IBAction func Player1Minus1(_ sender: Any) {
//        player1Life -= 1
//        updateHealthBars()
//        checkForWinner()
//    }
//    
//    @IBAction func Player1Minus5(_ sender: Any) {
//        // Safely convert the text to an integer. If conversion fails, default to adding 0.
//        if let changeAmount = Int(VariableChangeP.text ?? "0") {
//            player1Life -= changeAmount
//        } else {
//            // Optionally handle the error case if the text is not a valid integer
//            print("Invalid input: \(VariableChangeP.text ?? "nil")")
//        }
//        updateHealthBars()
//        checkForWinner()
//    }
//    
//    
//    @IBAction func Player2Plus5(_ sender: Any) {
//        if let changeAmount = Int(VariableChangeP.text ?? "0") {
//            player2Life += changeAmount
//        } else {
//            print("Invalid input: \(VariableChangeP.text ?? "nil")")
//        }
//        updateHealthBars()
//        checkForWinner()
//    }
//
//    
//    
//    @IBAction func Player2Plus1(_ sender: Any) {
//        player2Life += 1
//        updateHealthBars()
//        checkForWinner()
//    }
//    @IBAction func Player2Minus1(_ sender: Any) {
//        player2Life -= 1
//        updateHealthBars()
//        checkForWinner()
//    }
//    
//    @IBAction func Player2Minus5(_ sender: Any) {
//        if let changeAmount = Int(VariableChangeP.text ?? "0") {
//            player2Life -= changeAmount
//        } else {
//            print("Invalid input: \(VariableChangeP.text ?? "nil")")
//        }
//        updateHealthBars()
//        checkForWinner()
//    }
//
//    



    
    

  
    


//}

