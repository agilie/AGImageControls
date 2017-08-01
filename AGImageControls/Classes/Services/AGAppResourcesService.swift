//
//  AGAppResourcesService.swift
//  Pods
//
//  Created by Michael Liptuga on 28.07.17.
//
//

import Foundation
import UIKit

open class AGAppResourcesService {
    
    open static func getImage(_ name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        return UIImage(named: name, in: self.bundle(), compatibleWith: traitCollection) ?? UIImage()
    }
    
    open static func getPDFFile(_ name: String) -> CGPDFPage? {
        guard let path = self.bundle().path(forResource: name, ofType: "pdf") else { return nil }
        let url = URL(fileURLWithPath: path)
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        return document.page(at: 1)
    }
 
    open static func registrateAppFonts () {
        ["Anton-Regular", "CrimsonText-Bold", "HelveticaNeue", "MavenPro-Bold", "Montserrat-Bold", "OpenSans-Bold", "PatuaOne-Regular", "Poppins-Bold", "Poppins-Regular", "Raleway-Bold", "Rubik-Regular", "TitilliumWeb-Regular", "TitilliumWeb-Bold"].forEach {
           
            if let path = self.bundle().path(forResource: $0, ofType: "ttf") {
                if let inData = NSData(contentsOfFile: path) {
                    var error: Unmanaged<CFError>?
                    if let provider = CGDataProvider(data: inData) {
                        let font = CGFont(provider)
                        CTFontManagerRegisterGraphicsFont(font, &error)
                    }
                }
            }
        }
    }
    
    fileprivate class func bundle () -> Bundle {
        var bundle = Bundle(for: AGAppResourcesService.self)
        if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/AGImageControls.bundle") {
            bundle = resourceBundle
        }
        return bundle
    }
    
}
