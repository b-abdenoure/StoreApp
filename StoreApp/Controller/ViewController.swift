//
//  ViewController.swift
//  StoreApp
//
//  Created by Abdenoure Boudlal on 1/3/23.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllProduct()
        imageProduct.image = nil
        titleProduct.text = ""
        descriptionProduct.text = ""
        categoryProduct.text = ""
        idProduct.text = ""
        priceProduct.text = ""
        
    }
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var categoryProduct: UILabel!
    @IBOutlet weak var idProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    
    @IBOutlet weak var labelTest: UILabel!
    
    struct ProductModel {
        let id: Int
        let title: String
        let price: Double
        let description: String
        let image: String
        let category: String
        
        var idString: String{
            return String(id)
        }
        var priceString: String{
            return String(format: "%.2f", price)
        }
        
    }
    struct ProductData: Codable {
        let id: Int
        let title: String
        let price: Double
        let description: String
        let image: String
        let category: String
    }
    
    let productURL = "https://fakestoreapi.com/products"
    
    func fetchAllProduct(){
        let urlString = "\(productURL)/1"
        // string for limited fetch >>>> ?limit=3
        productFetch(with: urlString)
        print(urlString)
    }
    
    func productFetch(with urlString: String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data , response, error) in
                if error != nil{
                    return
                }
                if let safeData = data {
                    if let product = self.parseJSON(safeData){
                        self.didUpdateProduct(with: product)
                        //                            print(product.category)
                    }
                }
            }
            task.resume()
        }
    }
    
    //
    func parseJSON(_ productData: Data) -> ProductModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ProductData.self, from: productData)
            let id = decodedData.id
            let title = decodedData.title
            let price = decodedData.price
            let description = decodedData.description
            let image = decodedData.image
            let category = decodedData.category
            let product = ProductModel(id: id, title: title, price: price, description: description, image: image, category: category)
            //                print("---------------------------------\(productData.count)")
            
            return product
        }catch{
            //                Error
            //                delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //        func parseJSON2(_ productData: Data) -> ProductModel? {
    //            let product = try! JSONDecoder().decode([ProductData].self, from: productData)
    //            print("table >>>>>>>>>>> \(product[0].category)")
    //            print("table >>>>>>>>>>> \([product].count)")
    //
    //            return nil
    //        }
    
    //    var productManager = ProductManager()
    
    func didUpdateProduct(with product: ProductModel){
        print(product.id)
        print(product.image)
        print(product.title)
        print(product.description)
        print(product.price)
        print(product.category)

//        print(("\(product.image)".image ?? #imageLiteral(resourceName: "64470182_10220024470067527_3482262902667214848_n")) as UIImage)

        let url = URL(string: product.image)!

//            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageProduct.image = UIImage(data: data)
                    }
                }
//            }
        DispatchQueue.main.async {
            
//            self.imageProduct.image = "\(product.image)".image
        self.titleProduct.text = product.title
        self.descriptionProduct.text = product.description
        self.categoryProduct.text = product.category
        self.idProduct.text = product.idString
        self.priceProduct.text = product.priceString + " $"
    
            }
}
//    func toImage(product) -> UIImage? {
//            if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
//                return UIImage(data: data)
//            }
//            return nil
//        }
//var products = ProductModel(id: Int, title: String, price: Double, description: String, image: String, category: String)

}

//public extension String {
//    var image: UIImage? { get { return UIImage(named: self) } }
//}

