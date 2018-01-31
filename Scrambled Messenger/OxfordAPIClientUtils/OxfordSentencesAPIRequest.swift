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
        self.endpoint = .entries
    
    }
    
    override func getURLString() -> String {
        
        var urlString = self.baseURLString
        
        
        urlString = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: urlString)

        urlString = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlString)
        
        urlString = getURLStringFromAppendingQueryWord(relativeToURLString: urlString)
        
        return urlString.appending("sentences")
        
    }
}

