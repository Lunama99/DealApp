//
//  VoucherDetailViewModel.swift
//  DealApp
//
//  Created by Macbook on 20/10/2021.
//

import Foundation

class VoucherDetailViewModel {
    private let voucherRepo = VoucherRepository()
    var voucher: GetVoucher = GetVoucher()
    var vendor: GetListVendorRegister = GetListVendorRegister()
}
