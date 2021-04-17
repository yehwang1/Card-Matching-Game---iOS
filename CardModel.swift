//
//  CardModel.swift
//  cardMatchGame
//
//  Created by Brian Hwang on 7/3/20.
//  Copyright © 2020 Brian Hwang. All rights reserved.
//

import Foundation

class CardModel {
    //generates cards
    func getCards () -> [Card] {
        //array to store cards
        var cardArray = [Card]()
        //array to store used numbers
        var usedNumbers = [Int]()
        //add random 8 pairs of cards, no duplicate pairs
        while cardArray.count < 16 {
            let randomNumber = Int.random(in: 1...13)
            if !usedNumbers.contains(randomNumber) {
                let cardOne = Card()
                let cardTwo = Card()
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                cardArray.append(cardOne)
                cardArray.append(cardTwo)
                usedNumbers.append(randomNumber)
            }
        }
        //shuffle cards
        cardArray.shuffle()
        //return array of cards
        return cardArray
    }
}
