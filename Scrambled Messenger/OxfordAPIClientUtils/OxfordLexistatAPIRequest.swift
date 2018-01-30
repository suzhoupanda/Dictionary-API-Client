//
//  OxfordLexistatAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordLexistatAPIRequest: OxfordAPIRequest{
    private var ngram_size: NGramSize = NGramSize.ngram1
    
    private var wordform: String?{
        
        set(newValue){
            
            self.wordforms = newValue == nil ? nil : [newValue!]
            
        }
        
        get{
            return self.wordforms?.first
        }
    }
    
    private var wordforms: [String]?
    
    
    private var trueCase: String?{
        
        set(newValue){
            
            self.trueCases = newValue == nil ? nil : [newValue!]
            
        }
        
        get{
            return self.trueCases?.first
        }
    }
    private var trueCases: [String]?
    
    
    private var lemma: String?{
        
        set(newValue){
            
            self.lemmas = newValue == nil ? nil : [newValue!]
            
        }
        
        get{
            return self.lemmas?.first
        }
    }
    
    private var lemmas: [String]?
    
    
    
    /** Initializes a LexiStat API request for a single word **/
    
    init(withLemma userLemma: String, userTrueCase: String, userWordForm: String, filters: [OxfordAPIEndpoint.OxfordAPIFilter]?){
        
        self.endpoint = OxfordAPIEndpoint.stats_word_frequency
        self.word = String()
        
        self.lemma = userLemma
        self.wordform = userWordForm
        self.trueCase = userTrueCase
        
        self.filters = filters
        
        
        
    }
    
    /** Initializes a LexiStat API request for a list of words **/
    
    init(withLemmas userLemmas: [String]?, userTrueCases: [String]?, userWordForms: [String]?, collateOptions: [ValidCollateOption]?, sortOptions: [ValidSortOption]?, filters: [OxfordAPIEndpoint.OxfordAPIFilter]){
        
        self.endpoint = OxfordAPIEndpoint.stats_words_frequency
        
        self.lemmas = userLemmas
        self.trueCases = userTrueCases
        self.wordforms = userWordForms
        
        self.collateOptions = collateOptions
        self.sortOptions = sortOptions
        self.filters = filters
        
        self.word = String()
        
        
    }
    
    /** Initializer for querying the LexiStat ngram endpoint, which returns the frequencies of ngrams size 1-4. Include validation for the number of ngrams **/
    
    init(withLemma lemma: String, withNGramSize ngram_size: NGramSize, filterBy filterTokens: [String], withOtherNGramTokens otherNGramTokens: [String], withTokenReturnFormat tokenReturnFormat: TokenReturnFormat, shouldLookUpPunctuation: Bool, andWithOtherFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]){
        
        self.endpoint = OxfordAPIEndpoint.stats_ngrams_frequency
        self.ngram_size = ngram_size
        self.filterTokens = filterTokens
        self.otherContainedTokens = otherNGramTokens
        self.shouldLookUpPunctuationForNGrams = shouldLookUpPunctuation
        self.tokenReturnFormat = tokenReturnFormat
        self.filters = filters
        
        self.word = String()
        
        
    }
    
    
    
    private var filterTokens: [String]?
    
    private var otherContainedTokens: [String]?
    
    private var shouldLookUpPunctuationForNGrams = false
    
    private var collateOptions: [ValidCollateOption]?
    
    private var sortOptions: [ValidSortOption]?
    
    private var tokenReturnFormat: TokenReturnFormat = .SingleString
    
    
    
    override func getURLString() -> String {
        
    }
    
    
    private func getLexistatsURLString() -> String{
        
        let baseURLString = OxfordAPIRequest.baseURLString.appending("/")
        
        let endpointStr = self.endpoint.rawValue.appending("/")
        
        var nextStr = baseURLString.appending(endpointStr)
        
        if(self.endpoint == .stats_ngrams_frequency){
            
            return getNGramURLString(forEndpointString: nextStr)
            
        } else  {
            
            if let lemmas = self.lemmas{
                
                appendStringArrayElementsToURLString(fromStringArray: lemmas, toCurrentURLString: &nextStr)
                
            }
            
            if let wordforms = self.wordforms{
                
                appendStringArrayElementsToURLString(fromStringArray: wordforms, toCurrentURLString: &nextStr)
                
            }
            
            if let trueCases = self.trueCases{
                
                appendStringArrayElementsToURLString(fromStringArray: trueCases, toCurrentURLString: &nextStr)
                
            }
            
            if(self.endpoint == .stats_words_frequency){
                
                if let collateOptions = self.collateOptions{
                    
                    let stringArray = collateOptions.map({$0.rawValue})
                    appendStringArrayElementsToURLString(fromStringArray: stringArray, toCurrentURLString: &nextStr)
                }
                
                if let sortOptions = self.sortOptions{
                    let stringArray = sortOptions.map({$0.rawValue})
                    appendStringArrayElementsToURLString(fromStringArray: stringArray, toCurrentURLString: &nextStr)
                }
            }
            
            if let allFilters = self.filters{
                
                addFilters(filters: allFilters, toURLString: &nextStr)
                
            }
            
            
            return nextStr
        }
    }
    
    
    
    
    
    
    private func getNGramURLString(forEndpointString endpointURLString: String) -> String{
        
        let ngramStr = "\(self.ngram_size.rawValue)".appending("/")
        
        var nextStr = endpointURLString.appending(ngramStr)
        
        if let filterTokens = self.filterTokens{
            
            appendStringArrayElementsToURLString(fromStringArray: filterTokens, toCurrentURLString: &nextStr)
            
            
        }
        
        if let otherTokens = self.otherContainedTokens{
            
            appendStringArrayElementsToURLString(fromStringArray: otherTokens, toCurrentURLString: &nextStr)
            
        }
        
        nextStr = nextStr.appending("\(self.tokenReturnFormat.rawValue);")
        
        let shouldIncludePunctuationFlagStr = self.shouldLookUpPunctuationForNGrams ? "true" : "false"
        
        nextStr = nextStr.appending("\(shouldIncludePunctuationFlagStr);")
        
        
        
        if let allFilters = self.filters{
            
            addFilters(filters: allFilters, toURLString: &nextStr)
            
        }
        
        return nextStr
    }
    
    
}
