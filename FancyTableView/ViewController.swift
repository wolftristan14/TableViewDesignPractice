//
//  ViewController.swift
//  FancyTableView
//
//  Created by Tristan Wolf on 2018-06-13.
//  Copyright © 2018 Tristan Wolf. All rights reserved.
//

import UIKit
import SwiftyJSON
import ChameleonFramework

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    let FLICKR_API_KEY:String = "a1e806d948b247e67e2615ca12e4ce60"
    let FLICKR_URL:String = "https://api.flickr.com/services/rest/"
    let otherurl: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a1e806d948b247e67e2615ca12e4ce60&text=apples&per_page=20&format=json&nojsoncallback=1"
    let SEARCH_METHOD:String = "flickr.photos.search"
    let JSON_CALLBACK:String = "1"
    let PRIVACY_FILTER:String = "1"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var imageArray = [Image]()
    var image: Image!
    
    var selectedCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func urlToImageView(imageString: String, imageTitle: String) {
       // DispatchQueue.global(qos: .userInteractive).async {
            let url = URL(string: imageString)
            do {
                let imageData = try Data(contentsOf: url!)
                let image = UIImage(data: imageData)
                let imageObject = Image.init(image: image!, imageTitle: imageTitle)
                self.imageArray.append(imageObject)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //self.imageView.image = image

                    // put image somewhere
                }
            } catch {
                //self.urlToImageView(imageString: imageString)
                print("error getting image data from url")
            }
            

       // }
    }
    
    func displayImage() {
        DispatchQueue.global(qos: .userInteractive).async {

        let random = Int(arc4random_uniform(UInt32(19))) as Int
        self.dataTask?.cancel()

       // var url = URL(string: FLICKR_URL)
        var components = URLComponents(string: self.FLICKR_URL)
        components?.queryItems = [URLQueryItem(name: "method", value: self.SEARCH_METHOD), URLQueryItem(name: "api-key", value: self.FLICKR_API_KEY), URLQueryItem(name: "text", value: "apples"),  URLQueryItem(name: "privacy_filter", value: self.PRIVACY_FILTER), URLQueryItem(name: "perpage", value: "20"), URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "nojsoncallback", value: self.JSON_CALLBACK)]
        

        var url = URL(string: self.otherurl)
        var request = URLRequest(url: url!)
            request.httpMethod = "GET"

    

        
        

 
            self.dataTask = self.defaultSession.dataTask(with: request) { data, response, error in
                defer { self.dataTask = nil }
                // 5
                if let error = error {
                    print(error.localizedDescription)
                    //self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                        //var json:JSON = JSON(data)
                    var counter = 0
                    
                    while counter < 20 {
                         let innerJson = JSON(data)
                            //print("data:\(data)")
                         print("innderjson\(innerJson)")
                    var farm:String = innerJson["photos"]["photo"][counter]["farm"].stringValue
                            var server:String = innerJson["photos"]["photo"][counter]["server"].stringValue
                            var photoID:String = innerJson["photos"]["photo"][counter]["id"].stringValue

                            var secret:String = innerJson["photos"]["photo"][counter]["secret"].stringValue
                        var title:String = innerJson["photos"]["photo"][counter]["title"].stringValue

                        var imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg/"
                        print("imageString\(imageString)")
                        self.urlToImageView(imageString: imageString, imageTitle: title)
                        counter += 1
                    }
                }
                
        }
            self.dataTask?.resume()
        }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        image = imageArray[indexPath.row]
        
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.flatBlack.cgColor
        cell.layer.cornerRadius = 20.0
        cell.mainImageView.image = image.image
        cell.textView.text = image.imageTitle

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) ?? tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
        selectedCell.contentView.backgroundColor = UIColor.flatTealDark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) ?? tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
        selectedCell.contentView.backgroundColor = UIColor.flatBlack
    }


}


