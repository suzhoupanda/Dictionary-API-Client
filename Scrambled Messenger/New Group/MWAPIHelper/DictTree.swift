//
//  DictTree.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


class DictTree{
    
    var rootNode: DictNode
    var currentNode: DictNode?
    var currentChildIndex: Int = 0
    
    init(){
        rootNode = DictNode()
        rootNode.parentNode = nil
        currentNode = rootNode
    }
    
    func preorderAddNewNode(nextNode: DictNode){
        currentNode!.preorderAdd(childNode: nextNode)
        currentNode = nextNode
    }
    
    func inorderAddNewNode(nextNode: DictNode){
        if let parentNode = currentNode?.getParentNode(){
            currentNode = parentNode
            currentNode!.postOrderAdd(childNode: nextNode)
            currentNode = nextNode
        }
    }
    
    
    /**
    func preorderAdd(nextNode: DictNode){
        let node = getDeepestPreorderNode()
        node.preorderAdd(childNode: nextNode)
        
    }
    
    
    func postorderAdd(nextNode: DictNode){
        let node = getDeepestPostorderNode()
        node.postorderAdd(childNode: nextNode)
    }
    
    
    func getFirstInorderNode() -> DictNode?{
        /** If the current node has no children, then there is no preorder node to return **/
        if(rootNode.children == nil){
            return rootNode
        }
        
        if let firstNode = rootNode.children?.first{
            
            return firstNode
            
        } else {
            /** If the current node has an initialized array of children nodes but no stored nodes, then return nil **/
            return rootNode
        }
    }
    
    
    func getLastInorderNode() -> DictNode{
        /** If the current node has no children, then there is no preorder node to return **/
        if(rootNode.children == nil){
            return rootNode
        }
        
        if let lastNode = rootNode.children?.last{
            
            return lastNode
            
        } else {
            /** If the current node has an initialized array of children nodes but no stored nodes, then return nil **/
            return rootNode
        }
    }
    
    func getDeepestPostorderNode() -> DictNode{
        /** If the current node has no children, then there is no preorder node to return **/
        if(rootNode.children == nil){
            return rootNode
        }
        
        if let lastNode = rootNode.children?.last{
            
            if lastNode.children != nil{
                return getDeepestPostorderNode()
            } else {
                return lastNode
            }
        } else {
            /** If the current node has an initialized array of children nodes but no stored nodes, then return nil **/
            return rootNode
        }
    }
    
    func getDeepestPreorderNode() -> DictNode{
        
        /** If the current node has no children, then there is no preorder node to return **/
        if(rootNode.children == nil){
            return rootNode
        }
        

        if let firstNode = rootNode.children?.first{
            
            if firstNode.children != nil{
                return getDeepestPreorderNode()
            } else {
                return firstNode
            }
        } else {
            /** If the current node has an initialized array of children nodes but no stored nodes, then return nil **/
            return rootNode
        }
    }
    
     **/
}
