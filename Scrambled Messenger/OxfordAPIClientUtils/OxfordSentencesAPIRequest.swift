//
//  OxfordSentencesAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordSentencesAPIRequest: OxfordAPIRequest{
    
    
   init(withQueryWord queryWord: String) {
    
        super.init(withQueryWord: queryWord, andWithLanguage: .English)
    
    }
    
    override func getURLString() -> String {
        
        var baseURLString = self.baseURLString
        
        
        var urlStr = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: baseURLString)

        urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURLString)
        
        urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
        
        return urlStr.appending("sentences")
        
    }
}

