//
//  OxfordWordlistAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordWordlistAPIRequest: OxfordAPIRequest{
    
    init(withSourceLanguage sourceLanguage: OxfordAPILanguage,withDomainFilters domainFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withRegionFilters regionFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withRegisterFilters registerFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withTranslationsFilters translationsFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withLexicalCategoryFilters lexicalCategoryFilters: [OxfordAPIEndpoint.OxfordAPIFilter], withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        super.init(withQueryWord: String(), andWithLanguage: sourceLanguage)
        
        self.endpoint = OxfordAPIEndpoint.wordlist
        
        self.filters = domainFilters + regionFilters + registerFilters + translationsFilters + lexicalCategoryFilters
        

    }
    
    override func getURLString() -> String {
        
        var urlStr = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: baseURLString)
        
        urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlStr)
        
        
        if let allFilters = self.filters, allFilters.count > 0{
            
            addFilters(filters: allFilters, toURLString: &urlStr)
            
        } else {
            
            urlStr.removeLast()
        }
        
    
        
        return urlStr
    }
}
