//
//  OxfordTranslationsAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordTranslationsAPIRequest: OxfordAPIRequest{
    
    var targetLanguage: OxfordAPILanguage
    
    init(withQueryWord queryWord: String, withSourceLanguage sourceLanguage: OxfordAPILanguage, withTargetLanguage targetLanguage: OxfordAPILanguage){
        
        self.targetLanguage = targetLanguage
        
        super.init(withQueryWord: queryWord, andWithLanguage: sourceLanguage)
    }
    
    override func getURLString() -> String {
        
        var baseURL = self.baseURLString
        
        baseURL = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: baseURL)
        
        baseURL = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: baseURL)
        
        baseURL = getURLStringFromAppendingQueryWord(relativeToURLString: baseURL)
        
        baseURL.append("translations=\(self.targetLanguage.rawValue)")
        
        return baseURL
        
    }
}


