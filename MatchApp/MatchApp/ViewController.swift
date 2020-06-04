//
//  ViewController.swift
//  MatchApp
//
//  Created by Nikhil Mankani on 30/05/20.
//  Copyright © 2020 Nikhil Mankani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var start:Int = 0
    
    var disabledButton:UIButton?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var congoLabel: UILabel!
    
    
    @IBAction func startButton(_ sender: Any) {
        
        let disableMyButton = sender as? UIButton
        
        disabledButton = disableMyButton!
        
        //when button is clicked 
        start = 1
                
        disableMyButton?.isEnabled = false
        disableMyButton?.alpha = 0
        viewDidLoad()
        
    }
    
   let model = CardModel()
   var cardsArray = [Card]()

   var timer:Timer?
   
   var miliseconds:Int = 60 * 1000
   
   var firstFlippedCardIndex:IndexPath?
   
   var soundPlayer = SoundManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if start == 0{
            return
        }
        
        cardsArray = model.getCards()
        
        //set the view controller as the datasource and delegate of the collection view
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    //MARK: - Timer Methods
    
    @objc func timerFired(){
        
        // Decrement the counter
        miliseconds -= 1
        
        //update the label
        let seconds:Double = Double(miliseconds)/1000.0
        timerLabel.text = String(format: "Time remaining %.2f", seconds)
        
        //This fixes the problem where the timer would stop while scrolling the screen.
        RunLoop.main.add(timer!, forMode: .common)
        
        //Stop the timer if it reaches zero
        if miliseconds == 0{
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            //TODO: Check if the user has cleared all the carda
            checkForGameEnd()
            
        }
        
    }
    
    
    //MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return number of cards
        return cardsArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCellectionViewCell
        //here we are saying that treat the cell we are getting as a CardCellectionViewCell cell and the ! says that we are confident the cell we are getting is of the type mentioned after as keyword.
        //if you are not sure than you can use ? in place of ! and then check if it is not nill
    
        
        //Return it
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCellectionViewCell
        
        //Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        //Configure cell
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //chech if there is any time remaining . Don't the let the user interact if the time is 0
        
        if miliseconds <= 0 {
            return
        }
        
        //get a reference to the cell that was tapped
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCellectionViewCell
        
        //check the status of the card to deterime how to flip it
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            //flip the card up
            cell?.flipUp()
            
            // Play sound
            soundPlayer.playSound(effect: .flip)
            
            //Check if this is the first card that was flipped card or the second card
            
            if firstFlippedCardIndex==nil{
                
                //This is the first card flipped ever
                firstFlippedCardIndex = indexPath
                
            }
            
            else{
                
                //This is the second card that is flipped
                
                //Run the comparision logic
                checkForMatch(indexPath)
                
            }
            
        }
        
     
    }
    
    //MARK: - Game logic methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath){
        
        //get the two card objects for the two indices and see if they match
        
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        //get the two collection view cells that represent card one and two
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCellectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCellectionViewCell
        
        //Compare the two cards
        
        if cardOne.imageName == cardTwo.imageName{
            
            //It's a match
            
            // Play match sound
            soundPlayer.playSound(effect: .match)
            
            //set the status and remove them
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Was that the last pair
            checkForGameEnd()
            
        }
        
        else{
            
            //It's not a match
            
            // Play shuffle sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip them back over
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        //reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    
    func checkForGameEnd(){
        
        //check if there is any card that is unmatached
        //Assume that user has won and loop through all the cards to see if all of them are matched
        
        var hasWon = true
        
        for card in cardsArray{
            
            if card.isMatched == false{
                
                //we found a card which is not matched
                hasWon = false
                break
                
            }
            
        }
        
        if hasWon {
            
            //User has won , show an alert
            showAlert(title: "Congratulations", message: "You have won the Game!")
            timer?.invalidate()
            congoLabel.alpha = 1
        }
        
        else{
            
            //user hasn't won yet, check if there is any time left
            if miliseconds <= 0 {
                showAlert(title: "OOps!", message: "Time's Up!" )
                
            }
            
        }
        
    }
    
    func showAlert(title:String, message:String){
        
        //create an alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //add a button for the user to dismiss it
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        //add the ok button to the alert
        alert.addAction(okAction)
        
        //show the alert
        present(alert, animated: true, completion: nil)
        
    }

}

