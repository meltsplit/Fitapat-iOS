//
//  BankAccount.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/31.
//

import Foundation

struct BankAccount {
    let holder: String
    let bank: String
    let accountNumber: String
    let accountNumberWithHyphen: String
    
    var fullAccount: String {
        get {
            accountNumber + " " + bank
        }
    }
}

extension BankAccount {
    static let meltsplitAccount = BankAccount(holder: "장석우",
                                              bank: "카카오뱅크",
                                              accountNumber: "3333281466448",
                                              accountNumberWithHyphen: "3333-28-1466448")     
}
