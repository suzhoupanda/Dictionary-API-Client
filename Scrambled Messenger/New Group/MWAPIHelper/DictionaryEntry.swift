//
//  DictionaryEntry.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class MWDictionaryEntry{
    
    static let kHeadWord = "headWord"
    static let kPronunciation = "pronunciation"
    static let kEtymology = "etymology"
    static let kAudioFilePath = "audioFilePath"
    static let kDefinitions = "definitions"
    static let kFunctionalLabel = "functionalLabel"
    
    /** Similar to an NSObject, where properties can be accessed through key-value coding **/
    
    var debugDescription: String{
        
        let headwordString = "The headword is: \(self.headWord)"
        let functionalLabelString = "The functional label is: \(self.functionalLabel)"
        let pronunciationString = "Pronunciation is: \(self.pronunciation)"
        let etymology = "Etymology is: \(self.etymology)"
        let definitions = (self.entryDict[MWDictionaryEntry.kDefinitions] as! [String]).reduce("Definitions include: ", { return "\($0)\n\($1)"})
        
        
        let audioFilePath = "Audio FilePath is: \(self.audioFilePath)"
        
        return "\n\(headwordString),\n\(functionalLabelString),\n\(etymology),\n\(pronunciationString),\n\(audioFilePath),\n\(definitions)"
    }
    
    var headWord: String{
        
        get{
            return self.entryDict[MWDictionaryEntry.kHeadWord] as! String
        }
        
        set{
            self.entryDict[MWDictionaryEntry.kHeadWord] = newValue
        }
        
    }
    
    var pronunciation: String{
        
        get{
            return self.entryDict[MWDictionaryEntry.kPronunciation] as! String
        }
        
        set{
            self.entryDict[MWDictionaryEntry.kPronunciation] = newValue
        }
        
    }
    
    var etymology: String{
        
        get{
            return self.entryDict[MWDictionaryEntry.kEtymology] as! String
        }
        
        set{
            self.entryDict[MWDictionaryEntry.kEtymology] = newValue
        }
        
    }
    
    
    var audioFilePath: String{
        
        get{
            return self.entryDict[MWDictionaryEntry.kAudioFilePath] as! String
        }
        
        set{
            self.entryDict[MWDictionaryEntry.kAudioFilePath] = newValue
        }
        
    }
    
    var functionalLabel: String{
        
        get{
            return self.entryDict[MWDictionaryEntry.kFunctionalLabel] as! String
        }
        
        set{
            self.entryDict[MWDictionaryEntry.kFunctionalLabel] = newValue
        }
        
    }
    
    var definitions: [String]{
        
        get{
            return self.entryDict[MWDictionaryEntry.kDefinitions] as! [String]
        }
        
        set{
            self.entryDict[MWDictionaryEntry.kDefinitions] = newValue
        }
        
    }
    
    func addDefinition(def: String){
        
        if var defArray = entryDict[MWDictionaryEntry.kDefinitions] as? [String]{
            defArray.append(def)

        }
    }
    
    var entryDict: [String: Any]!
    
    init(){
        
        entryDict = [
            MWDictionaryEntry.kHeadWord: String(),
            MWDictionaryEntry.kPronunciation: String(),
            MWDictionaryEntry.kEtymology: String(),
            MWDictionaryEntry.kAudioFilePath: String(),
            MWDictionaryEntry.kDefinitions: [String](),
            MWDictionaryEntry.kFunctionalLabel: String()
            
        ]
    }
    
  
    
}
