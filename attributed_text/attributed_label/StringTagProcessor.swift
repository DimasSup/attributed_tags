//
//  StringTagProcessor.swift
//  attributed_text
//
//  Created by Dimas on 15.01.2020.
//  Copyright © 2020 T.D.V.DG. All rights reserved.
//

import UIKit

class AutoresizedAttachment:NSTextAttachment{
	init(image:UIImage) {
		super.init(data: nil, ofType: nil)
		self.image = image
		self.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
		if let image = self.image{
			
			let imageHeight = (lineFrag.height*0.8);
			
			let rect = CGRect(x: 0, y: -lineFrag.height*0.1, width: image.size.width * (imageHeight/image.size.height) , height: imageHeight)
			return rect
		}
		return CGRect.zero
	}
}

public class StringTagProcessor{
	var bundle:Bundle
	init(bundle:Bundle) {
		self.bundle = bundle
	}
	
	func getImage(by key:String) -> UIImage?{
		var result:UIImage? = nil
		if(key.contains("/")){
			//MARK: Не совсем я понял что значит "Информация об изображениях в строке находится в тэгах типа [IC(name)], где name является названием изображения или его относительным путем.". Относительным путем от чего?
			let str = NSString(string:key)
			let path =  str.deletingLastPathComponent
			let name = NSString(string:str.lastPathComponent).deletingPathExtension
			let ext = str.pathExtension
			if let filePath = bundle.path(forResource: name, ofType: ext){
				result = UIImage(contentsOfFile: filePath)
			}
		}
		else{
			result = UIImage(named: key, in: bundle,compatibleWith: nil)
		}
		if result == nil{
			result = UIImage(named: "not_found",in: bundle,compatibleWith: nil)
		}
		return result
	}
	
	func processTags(in attributedString:NSMutableAttributedString){
		if let regexp = try? NSRegularExpression(pattern: "\\[IC\\((.*?)\\)\\]", options: .caseInsensitive){
			
			let matches = regexp.matches(in: attributedString.string, options: .init(rawValue: 0), range: NSMakeRange(0, attributedString.length))
			matches.enumerated().reversed().forEach { offset, element in
				
				if let range = Range(element.range(at: 1), in: attributedString.string), let image = self.getImage(by:String(attributedString.string[range])){
					let attachment = AutoresizedAttachment(image: image)
					attributedString.replaceCharacters(in: element.range, with: NSAttributedString(attachment: attachment))
				}
				else{
					attributedString.replaceCharacters(in: element.range, with: "")
				}
			}
		}
		
	}
}
