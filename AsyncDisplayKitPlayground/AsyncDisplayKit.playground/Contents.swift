//: Please build the scheme 'AsyncDisplayKitPlayground' first
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

import AsyncDisplayKit

var initialNode: ASDisplayNode

class InitialVC: ASViewController<ASDisplayNode> {
    
    
    
    init() {
    initialNode = ASDisplayNode()
    super.init(node: initialNode)
    initialNode.auto
        
        
    }

    
}

