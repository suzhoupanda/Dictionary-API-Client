//
//  DictNode.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class DictNode{
    
    /** Attribute Information **/
    
    var elementName: String?
    var headWord: String?
    
    /** Linked Nodes **/
    var parentNode: DictNode?
    var children: [DictNode]?
    
    
    func getParentNode() -> DictNode?{
        
        return parentNode
    }
    
    func getLastChildNode() -> DictNode?{
        
        if let lastChild = children?.last{
            return lastChild
        } else {
            return nil
        }
    }
    
    func postOrderAdd(childNode: DictNode){
        
        if var children = self.children{
            children.append(childNode)
        }
        
    }
    
    func preorderAdd(childNode: DictNode){
        if(children == nil){
            children = [DictNode]()
        }
        
        children!.insert(childNode, at: 0)
    }
    
    /**
    /** Convenience method that allows for a sister node to be added to parent node **/
    
    func inorderPrependSisterNode(sisterNode: DictNode){
        if let parent = self.parentNode{
            parent.children!.insert(sisterNode, at: 0)
        } else {
            print("Error: Sister node could not be added to this dictnode; check that this is not the root node")
        }
    }
    
    func inorderAppendSisterNode(sisterNode: DictNode){
        if let parent = self.parentNode{
            
            parent.children!.append(sisterNode)
        } else {
            print("Error: Sister node could not be added to this dictnode; check that this is not the root node")
        }
    }

    /** Add a child node to the current node **/
    
    
    func postorderAdd(childNode: DictNode){
        if(children == nil){
            children = [DictNode]()
        }
        
        children!.append(childNode)
    }
    
    
    func preorderAdd(childNode: DictNode){
        
        if(children == nil){
            children = [DictNode]()
            
        }
        
        children!.insert(childNode, at: 0)
        
    }
    
    **/
    
}
