//
//  OxfordDictionaryAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordLemmatronAPIRequest: OxfordAPIRequest{
    
    
    
    init(withInflectedWord inflectedWord: String, withFilters queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?, withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        super.init(withQueryWord: inflectedWord, andWithLanguage: queryLanguage)
        self.endpoint = OxfordAPIEndpoint.inflections
        self.word = inflectedWord
        self.filters = queryFilters
        self.language = queryLanguage
        
    }
    
    override func getURLString() -> String {
        
        
        
        var urlStr = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: baseURLString)
        
        urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlStr)
        
        urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
        
        if let allFilters = self.filters{
            
            addFilters(filters: allFilters, toURLString: &urlStr)
            
            
        }
        
        return urlStr
    }
}
