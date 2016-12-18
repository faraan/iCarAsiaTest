//
//  ViewController.h
//  TestiCarAsia
//
//  Created by Faran Ghani on 18/12/16.
//  Copyright © 2016 iCarAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageComposerView.h"


@interface ViewController : UIViewController<MessageComposerViewDelegate>

@property (nonatomic, strong) MessageComposerView *messageComposerView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsonMessageLabel;


@end

