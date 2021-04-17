//
//  ViewController.swift
//  cardMatchGame
//
//  Created by Brian Hwang on 7/2/20.
//  Copyright © 2020 Brian Hwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Class variables
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cards = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 6000 * 10
    
    var firstFlippedIndex:IndexPath?
//-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cards = model.getCards()
        
        //set ViewController as delegate + datasource for collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Initialize timer
        timer = Timer.scheduledTimer(timeInterval: 1/1000, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func timerFired () {
        //decrease timer every millisecond
        milliseconds -= 1
        
        //update label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time remaining: %.2f", seconds)
        
        //stop the timer if it reaches zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            checkForGameEnd()
        }
        
    }
    
    //MARK: - Collection View Delegate Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return # of cards
        return cards.count
    }
    
    //function that tells collectionView which cards to put
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //return the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cardCell = cell as? CardCollectionViewCell
        cardCell?.configureCell(card: cards[indexPath.row])
    }
    
    //function that handles taps
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //cell that was tapped
        let tappedCell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        //flip that card (up or down depending on status)
        if tappedCell?.card?.isFlipped == false && tappedCell?.card?.isMatched == false {
            tappedCell?.flipUp() //turn uppp
            //check if tappedCell is first or second card in potential match
            if firstFlippedIndex == nil { //tappedCell is first card
                firstFlippedIndex = indexPath
            }
            else { // tappedCell is second card in comparison
                // run comparison logic
                checkForMatch(secondFlippedIndex: indexPath)
            }
        }
    }
    //MARK: - Game Logic Functions
    
    //function for comparison logic
    func checkForMatch (secondFlippedIndex:IndexPath) {
        let cardOne = cards[firstFlippedIndex!.row]
        let cardTwo = cards[secondFlippedIndex.row]
        let cardOne_cell = collectionView.cellForItem(at: firstFlippedIndex!) as? CardCollectionViewCell
        let cardTwo_cell = collectionView.cellForItem(at: secondFlippedIndex) as? CardCollectionViewCell
        
        if cardOne.imageName == cardTwo.imageName { //matched
            cardOne.isMatched = true
            cardTwo.isMatched = true
            //remove cards
            cardOne_cell?.remove()
            cardTwo_cell?.remove()
            checkForGameEnd()
        }
        else { // no match, flip cards back over
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            cardOne_cell?.flipDown()
            cardTwo_cell?.flipDown()
        }
        firstFlippedIndex = nil
    }
    
    //function to check if user has won/lost
    func checkForGameEnd () {
        //check for any unmatched cards
        var hasWon = true
        for cardIndex in cards {
            if cardIndex.isMatched == false {
                hasWon = false
                break
            }
        }
        if hasWon { //User won the game, show a pop-up message
            showAlert(title: "Congratulations!", message: "You've won the game!")
        }
            
        else { //User hasn't won yet, check if time remains
            if milliseconds <= 0 { //if time is up
                showAlert(title: "Time's Up!", message: "You've lost the game.")
            }
        }
    }
    
    //function to show pop-up message
    func showAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //OK button allows user to dismiss the alert
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
}

