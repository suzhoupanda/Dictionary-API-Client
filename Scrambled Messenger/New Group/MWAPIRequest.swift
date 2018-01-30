//
//  MWAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


struct MWAPIRequest{
    
    let baseURL = "https://www.dictionaryapi.com/api/v1/references/collegiate/xml/"
    let apiDictionaryKey = "af1e0f0b-e58e-4d0e-9f2c-86d81c5c2331"
    let apiThesaurusKey = "ea924e5a-3687-43bc-981e-8363f6930d9b"
    
    var headWord: String
    var isRequestForThesaurusAPI = false
    
    init(withHeadWord userHeadWord: String, isThesaurusRequest: Bool){

        self.headWord = userHeadWord
        self.isRequestForThesaurusAPI = isThesaurusRequest
        
    }
    
    
    func generateURLRequest() -> URLRequest{
        
        let urlString = getURLString()
        
        let url = URL(string: urlString)!
        
        return getURLRequest(forURL: url)
    }
    
    private func getURLRequest(forURL url: URL) -> URLRequest{
        
        let request = URLRequest(url: url)
        
        /**
         
         Configure any header fields if necessary for the API Request
         
         **/
        
        return request
    }
    
    
    private func getURLString() -> String{
        
        let wordURL = baseURL.appending(self.headWord)
        
        let apiKey = self.isRequestForThesaurusAPI ? apiThesaurusKey : apiDictionaryKey
        
        let processedURL = wordURL.appending("?key=\(apiKey)")
        
        return processedURL
    }
}
