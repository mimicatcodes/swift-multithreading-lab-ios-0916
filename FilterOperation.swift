
import Foundation
import UIKit

class FilterOperation: Operation {
    
    var flatigram: Flatigram
    var filter: String
    
    init(flatigram: Flatigram, filter: String) {
        self.flatigram = flatigram
        self.filter = filter

    }
    
    override func main() {
        if let image = flatigram.image?.filter(with: filter) {
        flatigram.image = image
        }
        
        
    }
    
}

