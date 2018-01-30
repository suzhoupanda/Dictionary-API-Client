//
//  OxfordAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

struct OxfordAPIRequest{
    
    private static let baseURLString = "https://od-api.oxforddictionaries.com/api/v1"
    private static let appID = "acb61904"
    private static let appKey = "383d6f9739d4974fb81168976b6e991b"
    
    private static var baseURL: URL{
        return URL(string: baseURLString)!
    }
    
    private var endpoint: OxfordAPIEndpoint
    private var word: String
    private var language: OxfordAPILanguage = .English
    private var filters: [OxfordAPIEndpoint.OxfordAPIFilter]?
    
    private var hasRequestedExampleSentencesForWord = false
    private var hasRequestedSynonyms: Bool = false
    private var hasRequestAntonyms: Bool = false
    private var dictionaryEntryFilter: OxfordAPIEndpoint.DictionaryEntryFilter = OxfordAPIEndpoint.DictionaryEntryFilter.none
    
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
    
    
    
    private var filterTokens: [String]?
    
    private var otherContainedTokens: [String]?
    
    private var shouldLookUpPunctuationForNGrams = false
    
    private var collateOptions: [ValidCollateOption]?
    
    private var sortOptions: [ValidSortOption]?
    
    private var tokenReturnFormat: TokenReturnFormat = .SingleString
    
    /** Different Initializers are used to restrict the range of possible URL strings that can be generated **/
    
    init(withWord queryWord: String, withFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]?,forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = filters
        
        self.hasRequestedSynonyms = false
        self.hasRequestAntonyms = false
    }
    
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
    
    init(withWord queryWord: String, withDictionaryEntryFilter dictionaryEntryFilter: OxfordAPIEndpoint.DictionaryEntryFilter,forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.dictionaryEntryFilter = dictionaryEntryFilter
        self.hasRequestedSynonyms = false
        self.hasRequestAntonyms = false
    }
    
    
    
    init(withWord queryWord: String, hasRequestedAntonymsQuery: Bool, hasRequestedSynonymsQuery: Bool, forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.hasRequestedSynonyms = hasRequestedSynonymsQuery
        self.hasRequestAntonyms = hasRequestedAntonymsQuery
    }
    
    init(withWord queryWord: String, hasRequestedExampleSentences: Bool = true, forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.hasRequestedSynonyms = false
        self.hasRequestAntonyms = false
    }
    

    
    init(withDomainFilters domainFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withRegionFilters regionFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withRegisterFilters registerFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withTranslationsFilters translationsFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withLexicalCategoryFilters lexicalCategoryFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        
        self.endpoint = OxfordAPIEndpoint.wordlist
        self.word = String()
        self.filters = domainFilters + regionFilters + registerFilters + translationsFilters + lexicalCategoryFilters
        self.language = queryLanguage
        
        self.hasRequestAntonyms = false
        self.hasRequestedSynonyms = false
        
    }
    
    
    init(withHeadword headWord: String, withFilters queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?, withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.inflections
        self.word = headWord
        self.filters = queryFilters
        self.language = queryLanguage
        
        self.hasRequestAntonyms = false
        self.hasRequestedSynonyms = false
    }
    
    
    init(withEndpoint queryEndpoint: OxfordAPIEndpoint, withQueryWord queryWord: String, withFilters queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?, withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        
        self.endpoint = queryEndpoint
        self.word = queryWord
        self.filters = queryFilters
        self.language = queryLanguage
        
        self.hasRequestAntonyms = false
        self.hasRequestedSynonyms = false
        
    }
    
    /** Generic default initializers with placeholder values for variables is provided for convenience  **/
    init(){
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = "love"
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.hasRequestedSynonyms = false
        self.hasRequestAntonyms = false
        
    }
    
    
    //TODO: Compare the efficiency and speed of the two URLRequest generators - one that requires validation and the other that doesn't require it
    
    func generateValidatedURLRequest() throws -> URLRequest{
        
       
        guard hasValidFilters(filters: self.filters, forEndpoint: self.endpoint) else {
            
            throw NSError(domain: "OxfordAPIClientErrorDomain", code: 0, userInfo: nil)
            
        }
        
        let urlString = getURLString()
        
        let url = URL(string: urlString)!
        
        return getURLRequest(forURL: url)
    }
    
    func generateURLRequest() -> URLRequest{
        
        let urlString = getURLString()
        
        let url = URL(string: urlString)!
        
        return getURLRequest(forURL: url)
    }
    
    private func getURLRequest(forURL url: URL) -> URLRequest{
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(OxfordAPIRequest.appID, forHTTPHeaderField: "app_id")
        request.addValue(OxfordAPIRequest.appKey, forHTTPHeaderField: "app_key")
        
        return request
    }
    
 
    
    private func hasValidFilters(filters: [OxfordAPIEndpoint.OxfordAPIFilter]?,forEndpoint endpoint: OxfordAPIEndpoint) -> Bool {
        
        if(filters == nil || (filters != nil && filters!.isEmpty)){
            return true
        }
        
        let toCheckFilters = filters!
        
        let allowableFilterSet = endpoint.getAvailableFilters()

        print("Checking if the filters passed in are allowable")
        
        for filter in toCheckFilters{
            print("Testing the filter: \(filter.getDebugName())")
            if !allowableFilterSet.contains(filter){
                print("The allowable filters don't contain: \(filter.getDebugName())")
                return false
            }
        }
        
        return true
        
        
    }
    
  


   
    /** The getURLString method is exposed during development to allow for testing **/
    
     func getURLString() -> String{
        
        if(self.endpoint == .stats_word_frequency || self.endpoint == .stats_words_frequency || self.endpoint == .stats_ngrams_frequency){
            
            return getLexistatsURLString()
            
        }
        
        let baseURLString = OxfordAPIRequest.baseURLString.appending("/")

        
        if(self.endpoint == .wordlist){
            
            
            var urlStr = getURLStringFromAppendingEndpoingSpecifier(relativeToURLString: baseURLString)
            
            urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlStr)
            
            
            if let allFilters = self.filters{
                addFilters(filters: allFilters, toURLString: &urlStr)
            }
            
            return urlStr
            
        } else if (self.endpoint == .entries) {
            
            /** Makes a request to the Sentence Dictionary API **/
            if(self.hasRequestedExampleSentencesForWord){
                
                var urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURLString)
                
                urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
                
                return urlStr.appending("sentences")


                /** Makes a request to the Dictionary API **/
            } else {
                var urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURLString)
                
                urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
                
                if let allFilters = self.filters{
                    
                    addFilters(filters: allFilters, toURLString: &urlStr)
                    
        
                }
                
                return urlStr

            }
            
        } else if (self.endpoint == .inflections){
            
            var urlStr = getURLStringFromAppendingEndpoingSpecifier(relativeToURLString: baseURLString)
            
            urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlStr)
            
            urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
            
            if let allFilters = self.filters{
                
                addFilters(filters: allFilters, toURLString: &urlStr)
                
                
            }
            
            return urlStr
            
            
            
        } else if (self.endpoint == .search){
            
            //TODO: Not yet implemented

        } else if (self.endpoint == .translations){
            
            //TODO: Not yet implemented

        } else if(self.endpoint == .utility){
            
            //TODO: Not yet implemented
        }
        
        
        return String()
    }
        
    
    
    
    //MARK: ******** Helper Methods for Building API Request URL String
    
    private func addFilters(filters: [OxfordAPIEndpoint.OxfordAPIFilter], toURLString urlString: inout String){

        
        if(filters.isEmpty){
            return
        }
        
        filters.forEach({
            var filterString = $0.getQueryParameterString(isLastQueryParameter: false)
            urlString = urlString.appending(filterString)
        })
        
        
        repeat{
            
            if(urlString.last! == ";"){
                urlString.removeLast()
            }
            
        }while(urlString.last! == ";")
        
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
    
    private func appendStringArrayElementsToURLString(fromStringArray stringArray: [String],toCurrentURLString urlString: inout String){
        
        var concatenatedString = stringArray.reduce(String(), { $0.appending("\($1),")})
        concatenatedString.removeLast()
        concatenatedString.append(";")
        
        urlString = urlString.appending(concatenatedString)
    }
    
    
    //MARK: *****   Helper Functions for Building URLRequest String
    
    private func getURLStringFromAppendingQueryWord(relativeToURLString urlString: String) -> String{
        
        let encodedQueryWord = getEncodedQueryWord()
        
        return urlString.appending("\(encodedQueryWord)/")

        
    }
    
    private func getURLStringFromAppendingLanguageSpecifier(relativeToURLString urlString: String) -> String{
        
        
        return urlString.appending("\(self.language.rawValue)/")
    }
    
    private func getURLStringFromAppendingEndpoingSpecifier(relativeToURLString urlString: String) -> String{
        
        
        return urlString.appending("\(self.endpoint.rawValue)/")
        
    }
    
    
    
    /** Appends the Thesaurus query parameters to the ULR string; **/
    
    private func getURLStringFromAppendingThesaurusQueryParameters(relativeToURLString urlString: String) -> String{
        
        if(hasRequestAntonyms || hasRequestedSynonyms){
            
            if(hasRequestedSynonyms && hasRequestAntonyms){
                
                let finalURLString = urlString.appending("synonyms;antonyms")
                
                return finalURLString
                
            } else if(hasRequestedSynonyms){
                
                let finalURLString = urlString.appending("synonyms")
                
                return finalURLString
                
            } else if(hasRequestAntonyms){
                
                let finalURLString = urlString.appending("antonyms")
                
                return finalURLString
            }
            
            
        }
        
        return String()
    }
    
    //MARK: ****** Helper Function for Encoding Query Parameters
    
    private func getEncodedQueryWord() -> String{
        
        //Declare mutable, local version of word parameter
        return getEncodedString(fromRawString: self.word)
    }
    
    private func getEncodedString(fromRawString rawString: String) -> String{
        
        //Declare mutable, local version of string parameter
        var copiedString = rawString
        
        //Make the string lowercased
        copiedString = copiedString.lowercased()
        
        //Add percent encoding to the query parameter
        let percentEncoded_string = copiedString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        copiedString = percentEncoded_string == nil ? copiedString : percentEncoded_string!
        
        //Replace spaces with underscores
        copiedString = copiedString.replacingOccurrences(of: " ", with: "_")
        
        return copiedString
    }


    
}


