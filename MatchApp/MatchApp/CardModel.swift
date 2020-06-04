//
//  CardModel.swift
//  MatchApp
//
//  Created by Nikhil Mankani on 30/05/20.
//  Copyright © 2020 Nikhil Mankani. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() ->[Card] {
        
        // Declare an empty array
        var generatedCards = [Card]()
        var checkdupes = [Int]()
        
        // Randomly generate 8 pairs of cards
        for _ in 1...8{
            
            // Generate a random number
            var randomNumber = Int.random(in: 1...13)
            
            while checkdupes.contains(randomNumber) {
                randomNumber = Int.random(in: 1...13)
            }
            
            checkdupes.append(randomNumber)
            
            //create two new card objects
            let cardOne = Card()
            let cardTwo = Card()
            
            //set their image names
            cardOne.imageName = "card\(randomNumber)"
            cardTwo.imageName = "card\(randomNumber)"
            
            //Add them to the array
            generatedCards += [cardOne,cardTwo]
            
            //print(randomNumber)
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()
        
        // Return the array
         return generatedCards
    }
    
}
