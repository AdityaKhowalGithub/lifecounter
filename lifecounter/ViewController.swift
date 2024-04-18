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
    @IBOutlet weak var Label1: UILabel!
   
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
    
    var player1Life = 20
    var player2Life = 20
    
    func getAT(s: Int) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Futura-Bold", size: 30.0)!]
        return NSAttributedString(string: "\(s)", attributes: attributes)
    }
    func updateHealthBars() {
        Player1Health.isUserInteractionEnabled = false
        Player2Health.isUserInteractionEnabled = false
        Player1Health.setAttributedTitle(getAT(s: player1Life), for: .normal)
        Player2Health.setAttributedTitle(getAT(s: player2Life), for: .normal)
        Player1HealthBar.progress = Float(player1Life) / 20.0
        Player2HealthBar.progress = Float(player2Life) / 20.0
    }
    func checkForWinner() {
        if player1Life <= 0 {
            WinnerLooser.text = "Player 1 LOSES!"
            WinnerLooser.isHidden = false
        } else if player2Life <= 0 {
            WinnerLooser.text = "Player 2 LOSES!"
            WinnerLooser.isHidden = false
        }
    }
    
    @IBAction func Player1Plus5(_ sender: Any) {
        player1Life += 5
        updateHealthBars()
        checkForWinner()
    }
    
    @IBAction func Player1Plus1(_ sender: Any) {
        player1Life += 1
        updateHealthBars()
        checkForWinner()
    }
    
    @IBAction func Player1Minus1(_ sender: Any) {
        player1Life -= 1
        updateHealthBars()
        checkForWinner()
    }
    
    @IBAction func Player1Minus5(_ sender: Any) {
        player1Life -= 5
        updateHealthBars()
        checkForWinner()
    }
    
    
    @IBAction func Player2Plus5(_ sender: Any) {
        player2Life += 5
        updateHealthBars()
        checkForWinner()
    }
    
    @IBAction func Player2Plus1(_ sender: Any) {
        player2Life += 1
        updateHealthBars()
        checkForWinner()
    }
    @IBAction func Player2Minus1(_ sender: Any) {
        player2Life -= 1
        updateHealthBars()
        checkForWinner()
    }
    
    @IBAction func Player2Minus5(_ sender: Any) {
        player2Life -= 5
        updateHealthBars()
        checkForWinner()
    }
    



    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // set view background color to #FDFCDC
        updateHealthBars()

        view.addSubview(myView)
        WinnerLooser.isHidden = true
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
        [
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        myView.addSubview(PlayerStacks)
        PlayerStacks.translatesAutoresizingMaskIntoConstraints = false
         
         // Add constraints to position PlayerStacks within anotherView and center it
         NSLayoutConstraint.activate([
             PlayerStacks.centerXAnchor.constraint(equalTo: myView.anotherView.centerXAnchor),
             PlayerStacks.centerYAnchor.constraint(equalTo: myView.anotherView.centerYAnchor)
         ])
        
        

        
    }
    
    


}

