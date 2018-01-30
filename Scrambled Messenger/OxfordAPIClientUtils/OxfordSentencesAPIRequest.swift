//
//  OxfordSentencesAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordSentencesAPIRequest: OxfordAPIRequest{
    
    
    override init(withQueryWord queryWord: String) {
    
        super.init(withQueryWord: queryWord)
        
    }
    
    override func getURLString() -> String {
        
        var baseURLString = self.baseURLString
        
        
        var urlStr = getURLStringFromAppendingEndpoingSpecifier(relativeToURLString: baseURLString)

        urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURLString)
        
        urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
        
        return urlStr.appending("sentences")
        
    }
}

