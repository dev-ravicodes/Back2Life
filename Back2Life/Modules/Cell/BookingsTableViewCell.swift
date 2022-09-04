//
//  BookingsTableViewCell.swift
//  Back2Life
//
//  Created by Amalendu Kar on 14/05/21.
//

import UIKit
import Designable
import Kingfisher

class BookingsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var img_UserImage: UIImageView!
    //@IBOutlet weak var img_UserImage: DesignableImageView!
    @IBOutlet weak var img_Tester: UIImageView!{
        didSet{
            img_Tester.isHidden = true
        }
    }
    
    @IBOutlet weak var btn_VideoConnect: DesignableButton!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    
    //@IBOutlet weak var img_TesterImage: DesignableImageView!
    @IBOutlet weak var lbl_TesterName: UILabel!
    @IBOutlet weak var lbl_TestePhoneNumber: UILabel!
    @IBOutlet weak var testKitName: UILabel!
    
    @IBOutlet var FirstUserImage: UIImageView!{
        didSet{
            FirstUserImage.isHidden = true
        }
    }
    @IBOutlet var FirstUserName: UILabel!
    @IBOutlet var SecondUserImage: UIImageView!{
        didSet{
            SecondUserImage.isHidden = true
        }
    }
    @IBOutlet var SecondUserName: UILabel!
    @IBOutlet var ThirdUserImage: UIImageView!{
        didSet{
            ThirdUserImage.isHidden = true
        }
    }
    @IBOutlet var ThirdUserName: UILabel!
    @IBOutlet var FourthUserImage: UIImageView!{
        didSet{
            FourthUserImage.isHidden = true
        }
    }
    @IBOutlet var FourthUserName: UILabel!
    @IBOutlet var FifthUserImage: UIImageView!{
        didSet{
            FifthUserImage.isHidden = true
        }
    }
    @IBOutlet var FifthUserName: UILabel!
    
    var UserCount: Int?
    var testData : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //makeAddress()
        //makeTiming()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func SetData(data: ScheduleBookingData) {
        selectionStyle = .none
        lbl_Name.text = data.consumerProfile?.name
        lbl_date.text = MonthNameDateYear(date: data.date ?? "")
        lbl_Time.text = TimeFormat(time: data.time ?? "")
        //lbl_Location.text = data.address
        lbl_TesterName.text = data.tester?.name
        lbl_TestePhoneNumber.text = data.tester?.number
        let bookInfo = data.booking_info
        for item in [bookInfo] {
            print(item?.count as Any)
            UserCount = item?.count
        }
        testData = data.test_data_info ?? ""
        //testData?.dropFirst(2)
        let stripped = (testData?.dropFirst(4))
//        testKitName.text = "\(UserCount!)" + "\(stripped ?? "")"//data.test_data_info ?? ""
        testKitName.text = "\(stripped ?? "")"
        DispatchQueue.main.async {
            self.img_UserImage.kf.setImage(with: URL(string: data.consumerProfile?.photo ?? ""))
            self.img_Tester.kf.setImage(with: URL(string: data.tester?.photo ?? ""))
        }
    }
    func MonthNameDateYear(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateValue = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: dateValue)
    }
    func TimeFormat(time:String) -> String {
        let dateAsString = time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date ?? Date())
    }
    
    
    @IBAction func btn_Delete(_ sender: UIButton) {
    }
    
    // MARK: - Additional Helper Functions
    
    func makeAddress() {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: " Hofweg 29, 22085 Hamburg", attributes: [NSAttributedString.Key.font: AppFont.font(style: .medium, size: 16), NSAttributedString.Key.foregroundColor: AppColor.primaryLabelColor])
        
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "location")
        image1Attachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.insert(image1String, at: 0)
        
        // draw the result in a label
        //locationLabel.attributedText = fullString
    }
    
    func makeTiming() {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: " Donnerstag, 10 Mai  9:55 AM", attributes: [NSAttributedString.Key.font: AppFont.font(style: .medium, size: 16), NSAttributedString.Key.foregroundColor: AppColor.primaryLabelColor])
        
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "timing")
        image1Attachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.insert(image1String, at: 0)
        
        // draw the result in a label
        //timingLabel.attributedText = fullString
    }
    
}
