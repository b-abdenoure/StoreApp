//
//  TableViewController.swift
//  StoreApp
//
//  Created by Abdenoure Boudlal on 1/19/23.
//

import UIKit

class ProductsCell: UITableViewCell{
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    @IBOutlet weak var categoryCell: UILabel!
    @IBOutlet weak var idCell: UILabel!
    @IBOutlet weak var priceCell: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.image = #imageLiteral(resourceName: "IOS_logo")
        titleCell.text = ""
        descriptionCell.text = ""
        categoryCell.text = ""
        idCell.text = ""
        priceCell.text = ""
    }
    
}

class TableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllProduct()
    }
    
    @IBOutlet weak var productsTable: UITableView!
    
    struct ArrayProductModel: Decodable {
        let idProduct: String
        let titleProduct: String
        let priceProduct: String
        let descriptionProduct: String
        let imageProduct: String
        let categoryProduct: String
    }
    
    struct ArrayProductData: Codable {
        let idProduct: String
        let titleProduct: String
        let priceProduct: String
        let descriptionProduct: String
        let imageProduct: String
        let categoryProduct: String
    }
    
    var productsArray: [ArrayProductModel] = [ArrayProductModel]()
    
    //    var jsonData: Data?
    
    let productURL = "https://fakestoreapi.com/products"
    
    func fetchAllProduct(){
        let urlString = "\(productURL)"
        // string for limited fetch >>>> ?limit=3
        productFetchForTable(with: urlString)
        print(urlString)
    }
    
    func productFetchForTable(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data , response, error) in
                if error != nil{
                    return
                }
                if let safeData = data {
                    self.jsonSerialization(jsonData: safeData)
                    print(safeData)
                }
            }
            task.resume()
        }
    }
//    func parseJSON(jsonData: Data) {
//        jsonSerialization(jsonData: jsonData)
//    }
    
    func jsonSerialization(jsonData: Data) {
//        let decoder = JSONDecoder()
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Any]{
//                let item3 = try? decoder.decode(ArrayProductData.self, from: jsonData)
            for item in json{
                    print(item)
                    if let object = item as? [String: Any] {
                        let idProduct = object["id"] as? String ?? "epmty"
                        print("idiiiiii:\(idProduct)")
                        let titleProduct = object["title"] as? String ?? "epmty"
                        let priceProduct = object["price"] as? String ?? "epmty"
                        let descriptionProduct = object["description"] as? String ?? "epmty"
                        let imageProduct = object["image"] as? String ?? "epmty"
                        let categoryProduct = object["category"] as? String ?? "epmty"
                        
                        productsArray.append(
                            ArrayProductModel(
                                idProduct: idProduct,
                                titleProduct: titleProduct,
                                priceProduct: priceProduct + " $",
                                descriptionProduct: descriptionProduct,
                                imageProduct: imageProduct,
                                categoryProduct: categoryProduct
                            )
                        )
                    }
                }
            
            productsTable.reloadData()
            
        }

    }
    func jsonDecoder(jsonData: Data){
        let json = try! JSONDecoder().decode([ArrayProductModel].self, from: jsonData)
        for item in json {
            let idProduct = item.idProduct
            let titleProduct = item.titleProduct
            let priceProduct = item.priceProduct
            let descriptionProduct = item.descriptionProduct
            let imageProduct = item.imageProduct
            let categoryProduct = item.categoryProduct
            
            productsArray.append(
                ArrayProductModel(
                    idProduct: idProduct,
                    titleProduct: titleProduct,
                    priceProduct: priceProduct + " $",
                    descriptionProduct: descriptionProduct,
                    imageProduct: imageProduct,
                    categoryProduct: categoryProduct
                )
            )
        }
        productsTable.reloadData()
    }
}

extension TableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
	        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            as? ProductsCell
        let product = productsArray[indexPath.row]
        cell?.idCell.text = product.idProduct
        cell?.titleCell.text = product.titleProduct
        cell?.priceCell.text = product.priceProduct
        cell?.descriptionCell.text = product.descriptionProduct
        cell?.imageCell.image = UIImage(named: product.imageProduct)
        cell?.categoryCell.text = product.categoryProduct
        
        
        return cell!
    }
}
