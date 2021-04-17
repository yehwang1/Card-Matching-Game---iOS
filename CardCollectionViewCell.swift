//
//  CardCollectionViewCell.swift
//  cardMatchGame
//
//  Created by Brian Hwang on 7/4/20.
//  Copyright © 2020 Brian Hwang. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell (card:Card) {
        //keep track of said card
        self.card = card
        
        //set front image view
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        if card.isFlipped {
            //show front of card
            flipUp (speed: 0)
        }
        else {
            flipDown(speed: 0, delay: 0)
        }
    }
    
    // flip back of card to front of card
    func flipUp (speed:TimeInterval = 0.3) {
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        card?.isFlipped = true
    }
    
    // flip front of card to back of card
    func flipDown (speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        }
        card?.isFlipped = false
    }
    
    //remove card from screen after match
    func remove () {
        backImageView.alpha = 0
        //make the two cards fade out
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
