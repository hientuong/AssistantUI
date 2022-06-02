//
//  String+Extension.swift
//  Stil
//
//  Created by Gà Nguy Hiểm on 09/02/2021.
//

import Foundation
import UIKit

extension String {
    var isValidCharacterPassword: Bool {
        // http://emailregex.com/
        let regex = "(?=.*[A-Z])(?=.*\\d)(?=.*[a-z])"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isValidCountPassword: Bool {
        // http://emailregex.com/
        let regex = "^[A-Za-z\\d]{6,}$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isoDate: Date? {
        return self.date(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    }
    var isoDateCurrent: Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: self)
    }
}

extension String {

    func htmlToAttributedString(with font: UIFont?) -> NSMutableAttributedString {
        do {
            let str = self.replacingOccurrences(of: "<p><br></p>", with: "<p></p>")
            let modifiedFont = String(format:"<span style=\"font-family: 'Lato-Regular'; font-size: \(font?.pointSize ?? 14)\">%@</span>", str)
            guard let data = modifiedFont.data(using: .utf8) else { return NSMutableAttributedString() }
            let attribute = try NSMutableAttributedString(data: data, options:
                                                    [.documentType: NSAttributedString.DocumentType.html,
                                                     .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            let style = NSMutableParagraphStyle()
            style.paragraphSpacing = -1
            style.lineSpacing = 5
            attribute.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attribute.length))
            return attribute
        } catch {
            return NSMutableAttributedString()
        }
    }
}

extension NSAttributedString {
    func resizeAttachment(with width: CGFloat, height: CGFloat = 200) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: self)
        let range = NSRange(location: 0, length: attributedText.length)
        let options = NSAttributedString.EnumerationOptions(rawValue: 0)
        attributedText.enumerateAttribute(NSAttributedString.Key.attachment,
                                          in: range,
                                          options: options) { (value, range, _) in
            if let attachement = value as? NSTextAttachment,
                let image = attachement.image(forBounds: attachement.bounds,
                                              textContainer: NSTextContainer(),
                                              characterIndex: range.location) {
                let size = CGSize(width: width, height: height)
                let newImage = image.resize(size: size)
                let newAttribut = NSTextAttachment()
                newAttribut.image = newImage
                attributedText.addAttribute(.attachment, value: newAttribut, range: range)
            }
        }
        return attributedText
    }
}
