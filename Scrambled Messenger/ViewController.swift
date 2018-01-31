//
//  ViewController.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/19/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import UIKit
import SpriteKit
import TwitterKit

class ViewController: UIViewController {

    
    //MARK: ***** Parts of Speech Labels
    
    @IBOutlet weak var numberOfNounsLabel: UILabel!
    
    @IBOutlet weak var numberOfVerbsLabel: UILabel!
    
    @IBOutlet weak var numberOfAdjectivesLabel: UILabel!
    
    @IBOutlet weak var numberOfAdverbsLabel: UILabel!
    
    @IBOutlet weak var numberOfPrepositions: UILabel!
    
    @IBOutlet weak var numberOfPronouns: UILabel!
    
    @IBOutlet weak var numberOfDeterminers: UILabel!
    
    @IBOutlet weak var numberOfConjunctions: UILabel!
    
    
    //MARK: ********* Backing variables for number of different parts of speech
    
    var lexicalClassConfiguration: LexicalClassConfiguration = LexicalClassConfiguration()
   
  
    
    //MARK: ******** TextBox
    
    @IBOutlet weak var textBox: UITextView!
    
    
    @IBAction func processText(_ sender: Any) {
        
        if let rawText = textBox.text{
            
            let lexicalClassConfiguration = LinguisticTaggerHelper.getLexicalClassConfiguration(forText: rawText)
       
            print("Nouns: \(lexicalClassConfiguration.totalNouns), Verbs: \(lexicalClassConfiguration.totalVerbs), Adjectives: \(lexicalClassConfiguration.totalAdjectives)")
            

            setLabelsWith(aLexicalConfiguration: lexicalClassConfiguration)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

       /** DictionaryAPIClient.getJSONDictionaryForWord(word: "love") **/
        
        
        let wordlistRequest = OxfordWordlistAPIRequest(withSourceLanguage: .English, withDomainFilters: [OxfordAPIEndpoint.OxfordAPIFilter.domains([
                OxfordDomain.air_force.rawValue,
                OxfordDomain.amerindian.rawValue,
                OxfordDomain.alcoholic.rawValue,
                OxfordDomain.biblical.rawValue
            ])], withRegionFilters: [
                OxfordAPIEndpoint.OxfordAPIFilter.regions([
                    OxfordRegion.us.rawValue
                ])
            ], withRegisterFilters: [
                
            ], withTranslationsFilters: [
            
            ], withLexicalCategoryFilters: [
            
            ])
        
        let urlString = wordlistRequest.getURLString()
        
        print(urlString)
        
        OxfordAPIClient.sharedClient.getWordListJSONData(forSourceLanguage: .English, forDomainFilters: [.anatomy], forRegionFilters: [], forRegisterFilters: [], forLexicalCategoryFilters: [])
    }
    
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
       
     
    
        
    }
    
    
    private func setLabelsWith(aLexicalConfiguration: LexicalClassConfiguration){
        
        setLabelsWith(nouns: aLexicalConfiguration.totalNouns, verbs: aLexicalConfiguration.totalVerbs, adjectives: aLexicalConfiguration.totalAdjectives, adverbs: aLexicalConfiguration.totalAdverbs, pronouns: aLexicalConfiguration.totalPronouns, prepositions: aLexicalConfiguration.totalPrepositions, conjunctions: aLexicalConfiguration.totalConjunctions, determiners: aLexicalConfiguration.totalDeterminers)
    }
    
    private func setLabelsWith(nouns: Int, verbs: Int, adjectives: Int, adverbs: Int, pronouns: Int, prepositions: Int, conjunctions: Int, determiners: Int){
        
        numberOfNounsLabel.text = "\(nouns)"
        numberOfVerbsLabel.text = "\(verbs)"
        numberOfAdjectivesLabel.text = "\(adjectives)"
        numberOfAdverbsLabel.text = "\(adverbs)"
        numberOfPronouns.text = "\(pronouns)"
        
        numberOfPrepositions.text = "\(prepositions)"
        numberOfConjunctions.text = "\(conjunctions)"
        numberOfDeterminers.text = "\(determiners)"
        
    }
    
    
    
   


}

