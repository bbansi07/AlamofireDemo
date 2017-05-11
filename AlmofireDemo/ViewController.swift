//
//  ViewController.swift
//  AlmofireDemo
//

//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet var labelData: UILabel!
    var myImageView : UIImageView! = UIImageView()
    var urlString = "http://cookie.jsontest.com/"
    let imageUrl = "https://robohash.org/123.png"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let net = NetworkReachabilityManager()
        
        self.myImageView.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        
            if  net?.isReachable ?? false {
                
                getData()
                
                getImage()
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                     print(" connection")
                }else if(net?.isReachableOnWWAN)! {
                     print(" connection")
                }
                
            }else {
                print("no connection")
            }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK:- Alamofire Methods
    
    // For getting response from URL
    
    func getData(){
        Alamofire.request(urlString).responseJSON { response in
            print("response is \(response)")  // original URL request
           
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                self.labelData.text = "\(JSON)"
            }
      }
    
    }
    // For Fetching Image
    func getImage(){
        
        Alamofire.request(imageUrl).response { (response) in
            self.myImageView?.image = UIImage(data: response.data!, scale:1)
            self.view.addSubview(self.myImageView!)
            self.downloadImage()
        }
        
    }
    
    //For Download Image
    func downloadImage(){
        Alamofire.download(imageUrl).responseData { response in
            print("Temporary URL: \(response.temporaryURL)")
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("people.png")
            return (documentsURL, [.removePreviousFile])
        }
        
        Alamofire.download(imageUrl, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL{
               // completionHandler(destinationUrl)
                print("destination url is \(destinationUrl)")
            }
        }
    }
}

