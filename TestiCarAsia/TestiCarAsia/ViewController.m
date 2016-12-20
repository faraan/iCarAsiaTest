//
//  ViewController.m
//  TestiCarAsia
//
//  Created by Faran Ghani on 18/12/16.
//  Copyright © 2016 iCarAsia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

static NSString * const kValidEmail     = @"www.carlist.my";
static NSString * const kMessage        = @"message";
static NSString * const kLinks          = @"Links";
static NSString * const kUrl            = @"url";
static NSString * const kUrlTitle       = @"title";

@implementation ViewController{
    NSMutableDictionary *jsonDictionary;
    NSMutableArray *urlArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.messageComposerView = [[MessageComposerView alloc] init];
    self.messageComposerView.delegate = self;
    [self.view addSubview:self.messageComposerView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - messageComposer Delegate

-(void)messageComposerSendMessageClickedWithMessage:(NSString *)message{
    
    jsonDictionary = [NSMutableDictionary dictionary];
    urlArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *replacedString = [self blackListString:message];
        
        [jsonDictionary setObject:@[replacedString] forKey:kMessage];
        
        if (urlArray.count>0) {
            [jsonDictionary setObject:urlArray forKey:kLinks];
            
        }
        
        NSString *blactListedString = [weakSelf convertToJsonString:jsonDictionary];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_jsonMessageLabel sizeToFit];
            
            _jsonMessageLabel.text = blactListedString;
        });
    });
}

#pragma mark - Custom Methods

// Method to black list number and url

-(NSString *)blackListString:(NSString *)string{
               //handler:(void (^) (NSString *replacedString))completion{
    
    __block  NSString *replacedString = string;
    
    __weak typeof(self) weakSelf = self;

    
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                | NSTextCheckingTypePhoneNumber error:&error];
    
    NSArray *matches =[detector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *result in matches) {
        
        if ([result resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [result URL];
            
            if (![[url host] isEqualToString:kValidEmail]) {
                replacedString = [replacedString stringByReplacingOccurrencesOfString:[url absoluteString] withString:@"*****"];
                
            }else{
                replacedString = [replacedString stringByReplacingOccurrencesOfString:[url absoluteString] withString:@""];
                NSLog(@"url Title - %@",[self getUrlTitle:[url absoluteURL]]);
                
                NSString *titleString = [weakSelf getUrlTitle:[url absoluteURL]];
                NSDictionary *urlDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[url absoluteString],kUrl,titleString,kUrlTitle, nil];
                
                [urlArray addObject:urlDictionary];
            }
        }
        if ([result resultType] == NSTextCheckingTypePhoneNumber) {
            NSString *resultString  = [result phoneNumber];
            
            replacedString = [replacedString stringByReplacingOccurrencesOfString:resultString withString:@"*****"];
        }

    }

    return replacedString;
}

// Method to get URL Title.

-(NSString *)getUrlTitle:(NSURL *)url{
    
    NSString * htmlCode = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    NSString * start = @"<title>";
    NSRange range1 = [htmlCode rangeOfString:start];
    
    NSString * end = @"</title>";
    NSRange range2 = [htmlCode rangeOfString:end];
    
    NSString * titleString = [htmlCode substringWithRange:NSMakeRange(range1.location + 7, range2.location - range1.location - 7)];
    
    NSLog(@"substring is %@",titleString);

    return titleString;
}

// Method to JSON String.

-(NSString*) convertToJsonString:(NSDictionary *)dictionary {
    
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
