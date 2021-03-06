//
//  PaymentViewController.swift
//  MarketIosApp
//
//  Created by Guilherme Deconto on 23/04/20.
//  Copyright © 2020 Guilherme Deconto. All rights reserved.
//

import UIKit
import PKHUD

protocol PaymentViewControllerDelegate {
    func didGoBack(success: Bool)
}

class PaymentViewController: UIViewController {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPriceTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var product : [Product]?
    var totalPrice: Double = 0
    
    var delegate: PaymentViewControllerDelegate?
    
    var success: Bool = false
    
    var cellIdentifier = "PaymentResumeTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        for item in product ?? []{
            self.totalPrice += item.price
        }
        lbPrice.text = String.init(Double.init(totalPrice))
        
    }
    
    func postProducts(){
        PostProductService.postProducts(product: self.product ?? []).onSuccess { (_, result) in
            HUD.flash(.success, delay: 2.0){ finished in
                self.success = true
            }
        }.onFailure { (_, error) in
        }
    }

    @IBAction func didPressPay(_ sender: Any) {
        postProducts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.didGoBack(success: self.success)
    }
    
}
extension PaymentViewController : UITableViewDelegate{
    
}
extension PaymentViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.product != nil {
            return self.product!.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PaymentResumeTableViewCell
        let product = self.product?[indexPath.row]
        cell.lbProduct.text = product?.name
        cell.lbPrice.text = String.init(Double.init(product?.price ?? 0.0))
        return cell
    }
    
    
}
