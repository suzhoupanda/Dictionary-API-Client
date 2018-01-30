//
//  OxfordSentencesAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordSentencesAPIRequest: OxfordAPIRequest{
    
    override func getURLString() -> String {
        
        var urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURLString)
        
        urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
        
        return urlStr.appending("sentences")
        
        
    }
}

