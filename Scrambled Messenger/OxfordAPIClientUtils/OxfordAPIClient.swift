//
//  OxfordAPIClient.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordAPIClient: OxfordDictionaryAPIDelegate{
    
    static let sharedClient = OxfordAPIClient()
    
    /** Instance variables **/
    
    private var urlSession: URLSession!
    private var delegate: OxfordDictionaryAPIDelegate?
    
    private init(){
        urlSession = URLSession.shared
        delegate = self
    }
    
    func setOxfordDictionaryAPIClientDelegate(with apiDelegate: OxfordDictionaryAPIDelegate){
        
        self.delegate = apiDelegate
        
    }
    
    func resetDefaultDelegate(){
        self.delegate = self
    }
    
    
    
    func getLexistatJSONData(forLemma lemma: String, forTrueCase trueCase: String, forWordForm wordForm: String, withLexicalCategory lexicalCategory: OxfordLexicalCategory?){
        
        let filters = lexicalCategory == nil ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.lexicalCategory([lexicalCategory!.rawValue])]
        
        let apiRequest = OxfordLexistatAPIRequest(withLemma: lemma, trueCase: trueCase, wordForm: wordForm, filters: filters)
        
        print("The url generated for this request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func getLexistatJSONData(withNGramSize nGramSize: NGramSize, forSearchTokens searchTokens: [String], withOtherTokens otherTokens: [String], includesPunctuationMarks: Bool, withTokenReturnFormat tokenReturnFormat: TokenReturnFormat, forSourceLanguage sourceLanguage: OxfordAPILanguage){
        
        let apiRequest = OxfordLexistatAPIRequest(withNGramSize: nGramSize, filterBy: searchTokens, withOtherNGramTokens: otherTokens, withTokenReturnFormat: tokenReturnFormat, shouldLookUpPunctuation: includesPunctuationMarks, andWithOtherFilters: [], forSourceLanguage: sourceLanguage)
        
        print("The url generated for this request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    
    func getLemmatronJSONData(forInflectedWord inflectedWord: String, forLanguage language: OxfordAPILanguage){
        
        
        downloadLemmatronJSONData(forInflectedWord: inflectedWord, forLanguage: language, andWithFilters: nil)
    }
    
    
    func getLemmatronJSONData(forInflectedWord inflectedWord: String, forLanguage language: OxfordAPILanguage, forLexicalCategories lexicalCategories: [OxfordLexicalCategory], forGrammaticalFeatures grammaticalFeatures: [OxfordGrammaticalFeature]){
        
        let lexicalCategoryStrings = lexicalCategories.map({$0.rawValue})
        
        let lexCategoryFilter = lexicalCategoryStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.lexicalCategory(lexicalCategoryStrings)]
        
        let grammaticalFeatureStrings = grammaticalFeatures.map({$0.rawValue})
        
        let grammaticalFeatureFilter = grammaticalFeatureStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.grammaticalFeatures(grammaticalFeatureStrings)]
        
        let allFilters = grammaticalFeatureFilter + lexCategoryFilter
 
        downloadLemmatronJSONData(forInflectedWord: inflectedWord, forLanguage: language, andWithFilters: allFilters)
    }
    
    
    
    
    private func downloadLemmatronJSONData(forInflectedWord inflectedWord: String, forLanguage language: OxfordAPILanguage, andWithFilters filters: [OxfordAPIEndpoint.OxfordAPIFilter]?){
        
        let apiRequest = OxfordLemmatronAPIRequest(withInflectedWord: inflectedWord, withFilters: filters, withQueryLanguage: language)
        
        print("The url string for this api request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
        
    }
    
    /** Note: Refactor method to include a parameter for the translation parameters **/
    func getWordListJSONData(forSourceLanguage sourceLanguage: OxfordAPILanguage, forDomainFilters domainFilters: [OxfordDomain], forRegionFilters regionFilters: [OxfordRegion], forRegisterFilters registerFilters: [OxfordLanguageRegister], forLexicalCategoryFilters lexicalCategoryFilters: [OxfordLexicalCategory]){
        
        let domainFilterStrings = domainFilters.map({$0.rawValue})
        let regionFilterStrings = regionFilters.map({$0.rawValue})
        let registerFilterStrings = registerFilters.map({$0.rawValue})
        let lexicalCategoryStrings = lexicalCategoryFilters.map({$0.rawValue})
        
        let mDomainFilters = domainFilterStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.domains(domainFilterStrings)]
        
        let mRegionFilters = regionFilterStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.regions(regionFilterStrings)]

        let mRegisterFilters = registerFilterStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.registers(registerFilterStrings)]
        
        let mLexCategoryFilters = lexicalCategoryStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.lexicalCategory(lexicalCategoryStrings)]

        downloadWordListJSONData(forSourceLanguage: sourceLanguage, forDomainFilters: mDomainFilters, forRegionFilters: mRegionFilters, forRegisterFilters: mRegisterFilters, forTranslationFilters: [], forLexicalCategoryFilters: mLexCategoryFilters)
    }
    
    func downloadDictionaryEntryJSONData(forWord queryWord: String, andForLanguage language:OxfordAPILanguage){
        
        let apiRequest = OxfordAPIRequest(withQueryWord: queryWord, andWithLanguage: language)

        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadDictionaryEntryJSONData(forWord word: String, andForEntryFilter entryFilter: OxfordAPIEndpoint.DictionaryEntryFilter){
        
        let apiRequest = OxfordAPIRequest(withWord: word, withDictionaryEntryFilter: entryFilter)
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadExampleSentencesJSONData(forWord word: String){
        
        let apiRequest = OxfordSentencesAPIRequest(withQueryWord: word)
        
        print("The url string for this request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadAPIUtilityRequestJSONData(forRESTEndpoint endpoint: OxfordUtilityAPIRequest.UtiltyRequestEndpoint, andWithTargetLanguage targetLanguage: OxfordAPILanguage?, andWithEndpointForAllFiltersRequest endpointForAllFiltersRequest: OxfordAPIEndpoint){
        
        let apiRequest = OxfordUtilityAPIRequest(withUtilityRequestEndpoint: endpoint, andWithTargetLanguage: targetLanguage, andWithEndpointForAllFiltersRequest: endpointForAllFiltersRequest)
        
        print("The url string generated from this request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadThesaurusJSONData(forWord word: String, withAntonyms isAntonymRequest: Bool, withSynonyms isSynonymRequest: Bool){
        
        let apiRequest = OxfordThesaurusAPIRequest(withWord: word, isAntonymRequest: isAntonymRequest, isSynonymRequest: isSynonymRequest)
        
        print("The url string generated from this api request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    
    
    private func downloadWordListJSONData(forSourceLanguage sourceLanguage: OxfordAPILanguage, forDomainFilters domainFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forRegionFilters regionFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forRegisterFilters registerFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forTranslationFilters translationFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forLexicalCategoryFilters lexicalCategoryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]){
        
        let apiRequest = OxfordWordlistAPIRequest(withSourceLanguage: sourceLanguage, withDomainFilters: domainFilters, withRegionFilters: regionFilters, withRegisterFilters: registerFilters, withTranslationsFilters: translationFilters, withLexicalCategoryFilters: lexicalCategoryFilters)
        
        let urlString = apiRequest.getURLString()
        
        print("The url string generated from this apiRequest is: \(urlString)")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    
    
    func downloadWordlistJSONDataWithValidation(forSourceLanguage sourceLanguage: OxfordAPILanguage, forDomainFilters domainFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forRegionFilters regionFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forRegisterFilters registerFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forTranslationFilters translationFilters: [OxfordAPIEndpoint.OxfordAPIFilter], forLexicalCategoryFilters lexicalCategoryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]){
        
        let apiRequest = OxfordWordlistAPIRequest(withSourceLanguage: sourceLanguage, withDomainFilters: domainFilters, withRegionFilters: regionFilters, withRegisterFilters: registerFilters, withTranslationsFilters: translationFilters, withLexicalCategoryFilters: lexicalCategoryFilters)
        
        let urlRequest = apiRequest.generateURLRequest()
    
        do {
            
            let urlRequest = try apiRequest.generateValidatedURLRequest()
            
            self.startDataTask(withURLRequest: urlRequest)

        } catch let error as NSError {
            
            guard let apiDelegate = self.delegate else {
                fatalError("Error: no delegate specified for Oxford API download task")
            }
            
            apiDelegate.didFailToConnectToEndpoint(withError: error)
        }
        
        
    }
    
    /** Wrapper function for executing aynchronous download of JSON data from Oxford Dictionary API **/
    
    private func startDataTask(withURLRequest request: URLRequest){
        
        guard let delegate = self.delegate else {
            fatalError("Error: no delegate specified for Oxford API download task")
        }
        
        _ = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            switch (data,response,error){
            case (.some,.some,.none),(.some,.some,.some): //Able to connect to the server, data received
                
                let httpResponse = (response! as! HTTPURLResponse)
                
                
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONResponse{
                    //Data received, and JSON serialization successful
                    
                    delegate.didFinishReceivingJSONData(withJSONResponse: jsonResponse, withHTTPResponse: httpResponse)
                    
                } else{
                    //Data received, but JSON serialization not successful
                    delegate.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                
                break
            case (.none,.some,.none),(.none,.some,.some): //Able to connect to the server but failed to get data or received a bad HTTP Response
                if let httpResponse = (response as? HTTPURLResponse){
                    delegate.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                break
            case (.none,.none,.some): //Unable to connect to the server, with an error received
                delegate.didFailToConnectToEndpoint(withError: error!)
                break
            case (.none,.none,.none): //Unable to connect to the server, no error received
                let error = NSError(domain: "Failed to get a response: Error occurred while attempting to connect to the server", code: 0, userInfo: nil)
                delegate.didFailToConnectToEndpoint(withError: error)
                break
            default:
                break
            }
            
        }).resume()
    }
    
}



//MARK: ********* Conformance to DictionaryAPIClient protocol methods

extension OxfordAPIClient{
    
    /** Unable to establish a connection with the server **/
    
    internal func didFailToConnectToEndpoint(withError error: Error) {
        
        print("Error occurred while attempting to connect to the server: \(error.localizedDescription)")
        
        
    }
    
    /** Proper credentials are provided, the API request can be authenticated; an HTTP Response is received but no data is provided **/
    
    
    internal func didFailToGetJSONData(withHTTPResponse httpResponse: HTTPURLResponse){
        print("Unable to get JSON data with http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
        
        
    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and the data is provided by the raw data could not be parsed into a JSON object **/
    
    internal func didFailToSerializeJSONData(withHTTPResponse httpResponse: HTTPURLResponse){
        
        print("Unable to serialize the data into a json response, http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
    }
    
    
    
    /** If erroneous credentials are provided, the API request can't be authenticated; an HTTP Response is received but no data is provided **/
    
    internal func didFinishReceivingHTTPResponse(withHTTPResponse httpResponse: HTTPURLResponse){
        
        print("HTTP response received with status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and serialized JSON data is provided **/
    
    internal func didFinishReceivingJSONData(withJSONResponse jsonResponse: JSONResponse, withHTTPResponse httpResponse: HTTPURLResponse) {
        
        print("JSON response received, http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
        
        print("JSON data received as follows:")
        print(jsonResponse)
    }
    
    func showOxfordStatusCodeMessage(forHTTPResponse httpResponse: HTTPURLResponse){
        
        if let oxfordStatusCode = OxfordHTTPStatusCode(rawValue: httpResponse.statusCode){
            let statusCodeMessage = oxfordStatusCode.statusCodeMessage()
            print("Status Code Message: \(statusCodeMessage)")
        }
        
        
    }
}
