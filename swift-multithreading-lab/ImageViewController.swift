
import Foundation
import UIKit
import CoreImage


//MARK: Image View Controller

class ImageViewController : UIViewController {
    
    var scrollView: UIScrollView!
    var imageView = UIImageView()
    let picker = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    let filtersToApply = ["CIBloom",
                          "CIPhotoEffectProcess",
                          "CIExposureAdjust"]
    
    var flatigram = Flatigram()
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setUpViews()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        selectImage()
    }
    
    @IBAction func filterButtonTapped(_ sender: AnyObject) {
        if flatigram.state == .unfiltered {
            self.starProcess()
        } else {
            presentFilteredAlert()
        }
    }
}


extension ImageViewController {
    
    func filterImage(with completion:@escaping (Bool)->()){
        
        let queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        
        for filter in filtersToApply {
            let filterer = FilterOperation(flatigram: flatigram, filter: filter)
            filterer.completionBlock = {
                if filterer.isCancelled {
                    completion(false)
                    return
                }
                
                if queue.operationCount == 0 {
                    DispatchQueue.main.async(execute: { 
                        self.flatigram.state = .filtered
                        completion(true)
                    })
                }
            }
            
            queue.addOperation(filterer)
            print("Added FilterOperation with \(filter) to \(queue.name!)")
        }
    }
    
    func starProcess(){
        filterButton.isEnabled = false
        chooseImageButton.isEnabled = false
        activityIndicator.startAnimating()
        filterImage { (success) in
            OperationQueue.main.addOperation({
                print("The result is :\(success)")
                self.filterButton.isEnabled = true
                self.chooseImageButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.imageView.image = self.flatigram.image
            })

        }
    
    }

}
