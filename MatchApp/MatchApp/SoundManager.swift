//
//  SoundManager.swift
//  MatchApp
//
//  Created by Nikhil Mankani on 02/06/20.
//  Copyright © 2020 Nikhil Mankani. All rights reserved.
//

import Foundation

import AVFoundation


class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum soundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:soundEffect){
        
        var soundFilename = ""
        
        switch effect {
            
            case .flip:
                soundFilename = "cardflip"
            
            case .match:
                soundFilename = "dingcorrect"
                
            case .nomatch:
                soundFilename = "dingwrong"
                
            case .shuffle:
                soundFilename = "shuffle"
            
        }
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // check that it's not nil
        
        guard bundlePath != nil else {
            //Couldn't find the resource exit
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            //Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            //Play the sond effect
            audioPlayer?.play()
        }
        
        catch{
            print("Couldn't create an audio player")
            return
        }
    }
    
}
