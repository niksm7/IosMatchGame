//
//  CardCellectionViewCell.swift
//  MatchApp
//
//  Created by Nikhil Mankani on 31/05/20.
//  Copyright © 2020 Nikhil Mankani. All rights reserved.
//

import UIKit

class CardCellectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card){
        
        //keep track of the card this cell represents
        self.card = card
        
        //set the front image view to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName) //this imageName came from Card.swift
        
        //reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        
        if card.isMatched == true{
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else{
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if card.isFlipped == true{
            
            //show the front image view
            flipUp(speed: 0)
            
        }
            
        else{
            
            //show the back image view
            flipDown(speed: 0,delay: 0)
            
        }
        
        
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        
        //flipup animation
        
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        
        //here we have used two transitions the first one showHideTransitionViews will hide the back image that is flipped and the second on transitionFlipFromLeft will flip from left.
        
        //set the status of the card
        
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay:TimeInterval = 0.5){
        
        //set the status of the card
        
        card?.isFlipped = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay) {
            
            //flipdown animation
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
            
        }
        
        
    }
    
    func remove(){
        
        //make the image views invisible
        
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)
        
    }
    
}
