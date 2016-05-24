//
//  ChatTableViewCell.swift
//  FourthBranchMessenger
//
//  Created by Matthew Tso on 5/3/16.
//  Copyright © 2016 Studio Tso. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    let messageLabel: UILabel = UILabel()
    private let bubbleImageView = UIImageView()
    
//    private var outgoingConstraint: NSLayoutConstraint!
//    private var incomingConstraint: NSLayoutConstraint!
    
    private var outgoingConstraints: [NSLayoutConstraint]!
    private var incomingConstraints: [NSLayoutConstraint]!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraintEqualToAnchor(bubbleImageView.centerXAnchor).active = true
        messageLabel.centerYAnchor.constraintEqualToAnchor(bubbleImageView.centerYAnchor).active = true
        
        bubbleImageView.widthAnchor.constraintEqualToAnchor(messageLabel.widthAnchor, constant: 50).active = true
        bubbleImageView.heightAnchor.constraintEqualToAnchor(messageLabel.heightAnchor, constant: 20).active = true
        
//        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
//        bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
//        outgoingConstraint = bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor)
//        incomingConstraint = bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor)
        
        outgoingConstraints = [
            bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor),
            bubbleImageView.leadingAnchor.constraintGreaterThanOrEqualToAnchor(contentView.leadingAnchor, constant: 60)
        ]
        incomingConstraints = [
            bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor),
            bubbleImageView.trailingAnchor.constraintLessThanOrEqualToAnchor(contentView.trailingAnchor, constant: -60)
        ]
        
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 10).active = true
        bubbleImageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -10).active = true
        
        
        messageLabel.textAlignment = .Left
        messageLabel.numberOfLines = 0
        
//        let image = UIImage(named: "ChatBubble")//.imageWithRenderingMode(.AlwaysTemplate)
//        bubbleImageView.tintColor = UIColor.blueColor()
//        bubbleImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func incoming(incoming: Bool) {
        if incoming {
//            incomingConstraint.active = true
//            outgoingConstraint.active = false
            NSLayoutConstraint.deactivateConstraints(outgoingConstraints)
            NSLayoutConstraint.activateConstraints(incomingConstraints)
            
//            bubbleImageView.image = bubble.incoming
//            let image = UIImage(named: "ChatBubble")!.imageWithRenderingMode(.AlwaysTemplate)
//            bubbleImageView.tintColor = UIColor.blueColor()
            
//            bubbleImageView.image = image
            messageLabel.textColor = UIColor.whiteColor()

            bubbleImageView.image = UIImage(named: "ChatBubble-incoming")
            
        } else {
//            incomingConstraint.active = false
//            outgoingConstraint.active = true
            NSLayoutConstraint.deactivateConstraints(incomingConstraints)
            NSLayoutConstraint.activateConstraints(outgoingConstraints)
            
            messageLabel.textColor = UIColor.grayColor()

//            bubbleImageView.image = bubble.outgoing
            bubbleImageView.image = UIImage(named: "ChatBubble-outgoing")
        }
    }
    
}

let bubble = makeBubble()

func makeBubble() -> (incoming: UIImage, outgoing: UIImage) {
    let image = UIImage(named: "ChatBubble")!
    
    // rendering mode .AlwaysTemplate doesn't work when changing the orientation
    let outgoing = coloredImage(image, red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    
    let flippedImage = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
    
    let incoming = coloredImage(flippedImage, red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
    
    return (incoming, outgoing)
}

func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, CGBlendMode.SourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return result
}
