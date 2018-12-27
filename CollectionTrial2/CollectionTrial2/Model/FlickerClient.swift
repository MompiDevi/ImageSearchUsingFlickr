//
//  FlickerClient.swift
//  CollectionTrial2
//
//  Created by N Mompi Devi on 30/01/18.
//  Copyright © 2018 N Mompi Devi. All rights reserved.
//

import UIKit

class FlickerClient: NSObject {

    func getData(searchTerm:String, closure: @escaping (_ result:table) -> Void){
        let queue=OperationQueue()
        
        let jsonUrl="https://api.flickr.com/services/feeds/photos_public.gne?tags=\(String(describing: searchTerm))&format=json&nojsoncallback=1"
        
        queue.addOperation {
            guard let url=URL(string:jsonUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data=data else{return}
                do{
                    let tab=try JSONDecoder().decode(table.self, from: data)
                    closure(tab)
                }catch let jsonerr{
                    print(jsonerr)
                }
                }.resume()
        }//queue
    }
    
}
