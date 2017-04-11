//
//  ViewController.swift
//  InAppPurchase
//
//  Created by Charles on 11/04/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {
    
    var productListFromAppleConnect = [SKProduct]()
    var currentProduct = SKProduct()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SKPaymentQueue.canMakePayments() {
            //STEP ONE: MAKE THE PRODUCT REQUEST FOR PRODUCT LIST FROM APPLE CONNECT
            print("IAP is enabled")
            let productIDs: NSSet = NSSet(objects: "product A", "product B")
            let productRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productIDs as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Please enable IAP")
        }
    }
    
    //To buy prodcut A
    @IBAction func purchaseProduct(_ sender:UIButton) {
        for product in productListFromAppleConnect {
            let productID = product.productIdentifier
            if productID == "product A" {
                currentProduct = product
                //TODO buy product
                buyProduct()
            }
        }
    }
    
    //SETP THREE: ADD OBSERVER AND PAYMENT TASK INTO THE QUEUE
    func buyProduct() {
        let pay = SKPayment(product: currentProduct)
        //add observer
        SKPaymentQueue.default().add(self)
        //add payment
        SKPaymentQueue.default().add(pay)
    }
    
    //To restore previous purchase
    @IBAction func restorePurchase(_ sender:UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension ViewController:SKProductsRequestDelegate {
    //STEP TWO: AFTER PRODUCT LIST RETURN STORE/DISPLAY THEM IN UI
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let products = response.products
        for product in products {
            print(product)
            productListFromAppleConnect.append(product)
        }
        
        //TODO upate UI
    }
}

extension ViewController:SKPaymentTransactionObserver {
    //STEP FOUR: AFTER USER PURCHASE THE PRODUCT, GIVE USER THE PRODUCT
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("payment updated")
        
        for transaction in transactions {
            let trans = transaction as SKPaymentTransaction
            
            switch trans.transactionState {
            case .purchased:
                print("purchased")
                //TODO unlock / give content / update UI
                
                let productID = currentProduct.productIdentifier
                switch productID {
                case "product A":
                    print("A restored")
                    
                case "product B":
                    print("B restored")
                    
                default:
                    print("product not found")
                }
                
                queue.finishTransaction(trans)
                
            case .failed:
                print("failed")
                queue.finishTransaction(trans)
                
            default:
                print("default")
//                queue.finishTransaction(trans)
            }
        }
    }
    
    //restore purchase
    //STEP ZERO: RESTORE USER'S PREVIOUS PURCHASE
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("payment restore")
        for transaction in queue.transactions {
            let t:SKPaymentTransaction = transaction
            let productID = t.transactionIdentifier!
            
            switch productID {
            case "product A":
                print("A restored")
                
            case "product B":
                print("B restored")
                
            default:
                print("product not found")
            }
        }
    }
}
