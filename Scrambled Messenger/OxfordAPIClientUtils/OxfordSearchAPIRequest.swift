//
//  OxfordSearchAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordSearchAPIRequest: OxfordAPIRequest{
    
    var filterByPrefix = false
    var targetLanguage: OxfordAPILanguage?
    var region: OxfordRegion?
    
    init(withQueryText queryText: String, withSourceLanguage sourceLanguage: OxfordAPILanguage, withTargetLanguage targetLanguage: OxfordAPILanguage?, filterByPrefix: Bool, filterByRegion region: OxfordRegion, limitResultsBy limit: Int = 5000, offsetResultsBy offset: Int = 0){
        
        super.init(withQueryWord: queryText, andWithLanguage: sourceLanguage)

        self.targetLanguage = targetLanguage
        self.filterByPrefix = filterByPrefix
        self.region = region
        self.resultLimit = limit
        self.resultOffset = offset
        
        
        self.endpoint = .search
    }
    
    
    override func getURLString() -> String {
        
        var baseURL = self.baseURLString
        
        baseURL = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: baseURL)
        
        baseURL = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURL)
        
        if let targetLanguage = self.targetLanguage{
            baseURL.append("translations=\(targetLanguage.rawValue)")
        }
        
        //TODO: not yet implemented
        /**
         q=
         limit=
         offset=
 
         **/
        
        return baseURL
    }
}
