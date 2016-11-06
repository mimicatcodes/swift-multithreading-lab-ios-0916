
import Foundation
import UIKit

class Flatigram {
    var image: UIImage?
    var state: ImageState = .unfiltered

    enum ImageState {
        case filtered, unfiltered
    }

}
