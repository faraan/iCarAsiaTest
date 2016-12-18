//
//  MessageComposerView.h
//  TestiCarAsia
//
//  Created by Faran Ghani on 18/12/16.
//  Copyright © 2016 iCarAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol MessageComposerViewDelegate <NSObject>
// delegate method executed after the user clicks the send button. Message is the message contained within the
// text view when send is pressed
- (void)messageComposerSendMessageClickedWithMessage:(NSString*)message;
@optional
// executed whenever the MessageComposerView's frame changes. Provides the frame it is changing to and the animation duration
- (void)messageComposerFrameDidChange:(CGRect)frame withAnimationDuration:(CGFloat)duration __attribute__((deprecated));
// executed whenever the MessageComposerView's frame changes. Provides the frame it is changing to and the animation duration
- (void)messageComposerFrameDidChange:(CGRect)frame withAnimationDuration:(CGFloat)duration andCurve:(NSInteger)curve;
// executed whenever the user is typing in the text view
- (void)messageComposerUserTyping;
@end

@interface MessageComposerView : UIView<UITextViewDelegate>
@property(nonatomic, weak) id<MessageComposerViewDelegate> delegate;
@property(nonatomic, strong) UITextView *messageTextView;
@property(nonatomic, strong) NSString *messagePlaceholder;
@property(nonatomic, strong) UIButton *sendButton;
@property(nonatomic) UIEdgeInsets composerBackgroundInsets;
@property(nonatomic) UIEdgeInsets composerTVInsets;
@property(nonatomic) NSInteger keyboardHeight;
@property(nonatomic) NSInteger keyboardAnimationCurve;
@property(nonatomic) CGFloat keyboardAnimationDuration;
@property(nonatomic) NSInteger keyboardOffset;
@property(nonatomic) NSInteger characterCap;
// configuration method.
- (void)setup;
// layout method
- (void)setupFrames;

// init with screen width and default height. Offset provided is space between composer and keyboard/bottom of screen
- (id)initWithKeyboardOffset:(NSInteger)offset andMaxHeight:(CGFloat)maxTVHeight;
// init with provided frame and offset between composer and keyboard/bottom of screen
- (id)initWithFrame:(CGRect)frame andKeyboardOffset:(NSInteger)offset;
// init with provided frame and offset between composer and keyboard/bottom of screen. Also set a max height on composer.
- (id)initWithFrame:(CGRect)frame andKeyboardOffset:(NSInteger)offset andMaxHeight:(CGFloat)maxTVHeight;
// provide a function to scroll the textview to bottom manually in fringe cases like loading message drafts etc.
- (void)scrollTextViewToBottom;
// for adding accessory views to the left of the messageTextView
- (void)configureWithAccessory:(UIView *)accessoryView;
// keyboarding resizing function in case you want to overwrite it
- (void)keyboardWillChangeFrame:(NSNotification *)notification;

// returns the current keyboard height. 0 if keyboard dismissed.
- (CGFloat)currentKeyboardHeight;

// To avoid exposing the UITextView and attempt to prevent bad practice, startEditing and finishEditing
// are available to become and resign first responder. This means you shouldn't have an excuse to
// do [messageComposerView.messageTextView resignFirstResponder] etc.
- (void)startEditing;
- (void)finishEditing;
@end
