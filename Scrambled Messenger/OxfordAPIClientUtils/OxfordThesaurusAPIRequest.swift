//
//  OxfordThesaurusAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordThesaurusAPIRequest: OxfordAPIRequest{
    
    private var hasRequestedSynonyms: Bool = false
    private var hasRequestAntonyms: Bool = false
    
    /** Appends the Thesaurus query parameters to the ULR string; **/
    
    private func getURLStringFromAppendingThesaurusQueryParameters(relativeToURLString urlString: String) -> String{
        
        
        if(hasRequestedSynonyms && hasRequestAntonyms){
            
            let finalURLString = urlString.appending("synonyms;antonyms")
            
            return finalURLString
            
        } else if(hasRequestedSynonyms){
            
            let finalURLString = urlString.appending("synonyms")
            
            return finalURLString
            
        } else if(hasRequestAntonyms){
            
            let finalURLString = urlString.appending("antonyms")
            
            return finalURLString
        }
        
        
        
        
    }
}