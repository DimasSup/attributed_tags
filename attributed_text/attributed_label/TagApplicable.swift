
import UIKit

// MARK: - TagApplicable

/*
 * Все, кто реализует этот протокол, должны иметь возможность отобразить тект
 * с изображениями.
 *
 * Изображения в строке представлены ключами вида `[IC(image_name)]`, где
 * `image_name` является названием изображения или его относительным путем.
 */
public protocol TagApplicable {
    
    /// Задание `attributedText` с изображениями
    func setTextWithTags(_ text: String)
}


private struct TagApplicableAssociatedKeys {
	static var stringTagProcessor: UInt8 = 0
}

public extension TagApplicable where Self: UILabel {
	
	var stringTagProcessor:StringTagProcessor?{
		get{
			return objc_getAssociatedObject(self,&TagApplicableAssociatedKeys.stringTagProcessor ) as? StringTagProcessor
		}
		set{
			objc_setAssociatedObject(self, &TagApplicableAssociatedKeys.stringTagProcessor , newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
    func setTextWithTags(_ text: String) {
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = self.textAlignment
		paragraph.lineBreakMode = self.lineBreakMode
		
		var attributes:[NSAttributedString.Key:Any] = [:]
		if let color = self.textColor{
			attributes[.foregroundColor] = color
		}
		if let font = self.font{
			attributes[.font] = font
		}
		
		
		let attString = NSMutableAttributedString(string: text, attributes: attributes)
		if let processor = self.stringTagProcessor{
			processor.processTags(in: attString)
		}
		
		self.attributedText = attString
		
    }
	
	
}

// MARK: - TagApplicable Conformances

extension UILabel: TagApplicable { }
