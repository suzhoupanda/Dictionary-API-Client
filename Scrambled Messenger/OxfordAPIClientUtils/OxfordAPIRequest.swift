//
//  OxfordAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation



class OxfordAPIRequest{
    
     static let baseURLString = "https://od-api.oxforddictionaries.com/api/v1"
     private static let appID = "acb61904"
     private static let appKey = "383d6f9739d4974fb81168976b6e991b"
    
    private static var baseURL: URL{
        return URL(string: baseURLString)!
    }
    
    var baseURLString: String{
        return OxfordAPIRequest.baseURLString
    }
    
     var endpoint: OxfordAPIEndpoint
     var word: String
     var language: OxfordAPILanguage = .English
     var filters: [OxfordAPIEndpoint.OxfordAPIFilter]?
    
 
    private var dictionaryEntryFilter: OxfordAPIEndpoint.DictionaryEntryFilter = OxfordAPIEndpoint.DictionaryEntryFilter.none
    
    /** Different Initializers are used to restrict the range of possible URL strings that can be generated **/
    
    init(withWord queryWord: String, withFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]?,forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = filters
        
       
    }
    
    init(withWord queryWord: String, withDictionaryEntryFilter dictionaryEntryFilter: OxfordAPIEndpoint.DictionaryEntryFilter,forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
        self.dictionaryEntryFilter = dictionaryEntryFilter
    
    }
    
    
    
    init(withWord queryWord: String, hasRequestedAntonymsQuery: Bool, hasRequestedSynonymsQuery: Bool, forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
    }
    
    init(withWord queryWord: String, hasRequestedExampleSentences: Bool = true, forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.language = OxfordAPILanguage.English
        self.filters = nil
        
 
    }
    

    
    init(withDomainFilters domainFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withRegionFilters regionFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withRegisterFilters registerFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withTranslationsFilters translationsFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withLexicalCategoryFilters lexicalCategoryFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        
        self.endpoint = OxfordAPIEndpoint.wordlist
        self.word = String()
        self.filters = domainFilters + regionFilters + registerFilters + translationsFilters + lexicalCategoryFilters
        self.language = queryLanguage
        
      
        
    }
    
    
    init(withHeadword headWord: String, withFilters queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?, withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        self.endpoint = OxfordAPIEndpoint.inflections
        self.word = headWord
        self.filters = queryFilters
        self.language = queryLanguage
        
            }
    
    
    init(withEndpoint queryEndpoint: OxfordAPIEndpoint, withQueryWord queryWord: String, withFilters queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?, withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        
        self.endpoint = queryEndpoint
        self.word = queryWord
        self.filters = queryFilters
        self.language = queryLanguage
        
        
    }
    
    /** Generic default initializers with placeholder values for variables is provided for convenience  **/
    init(){
        self.endpoint = OxfordAPIEndpoint.utility
        self.word = "love"
        self.language = OxfordAPILanguage.English
        self.filters = nil
    
        
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
        
        
        let baseURLString = OxfordAPIRequest.baseURLString.appending("/")

        
        if(self.endpoint == .wordlist){
            
            
         
            
        } else if (self.endpoint == .entries) {
            
            /** Makes a request to the Sentence Dictionary API **/
            if(self.hasRequestedExampleSentencesForWord){
                
               

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
    
     func addFilters(filters: [OxfordAPIEndpoint.OxfordAPIFilter], toURLString urlString: inout String){

        
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
    
    
    func appendStringArrayElementsToURLString(fromStringArray stringArray: [String],toCurrentURLString urlString: inout String){
        
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
    
    func getURLStringFromAppendingLanguageSpecifier(relativeToURLString urlString: String) -> String{
        
        
        return urlString.appending("\(self.language.rawValue)/")
    }
    
    private func getURLStringFromAppendingEndpoingSpecifier(relativeToURLString urlString: String) -> String{
        
        
        return urlString.appending("\(self.endpoint.rawValue)/")
        
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


