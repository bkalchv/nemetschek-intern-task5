//
//  SampleViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.04.22.
//

import UIKit

class SampleViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var dataTask: URLSessionDataTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSearchButtonPress(_ sender: Any) {
        // perform API query
        
        dataTask?.cancel()
                
        if let searchTextFieldText = searchTextField.text, var urlComponents = URLComponents(string: "https://www.googleapis.com/youtube/v3/search")  {
            
            urlComponents.query = "part=snippet&order=viewCount&q=\(searchTextFieldText)&type=video&key=\(Constants.API_KEY)"
            
            guard let youtubeApiURL = urlComponents.url else { return }
            
            let session = URLSession.shared
            
            var request = URLRequest(url: youtubeApiURL)
            request.setValue("servicecontrol.googleapis.com/net.nemetschek.PirateRadio", forHTTPHeaderField: "x-ios-bundle-identifier")
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            dataTask = session.dataTask(with: request) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                print("Response code = \((response as! HTTPURLResponse).statusCode)")
                if let error = error {
                    // TODO: Handle error
                    print("DataTask error: " + error.localizedDescription)
                } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 { // Successful response
                    
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        //print(JSONString)
                        
                        let responseData = Data(JSONString.utf8)
                        
                        let JSONDecoder = JSONDecoder()
                        JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        do {
                            let decodedSearchListResponse = try JSONDecoder.decode(YouTubeSearchListResponse.self, from: responseData)
                            print("Kind: \(decodedSearchListResponse.kind), etag:  \(decodedSearchListResponse.etag)")
                        } catch {
                            print("Error: \(error.localizedDescription)")
                            print(error)
                        }
                        
                        
                    }
                }
            }
            
            dataTask?.resume()
            print("DataTask started")
        }
       
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
