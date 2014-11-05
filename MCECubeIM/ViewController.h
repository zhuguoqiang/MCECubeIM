//
//  ViewController.h
//  MCECubeIM
//
//  Created by 朱国强 on 14-10-20.
//  Copyright (c) 2014年 MCECube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"

@interface ViewController : UIViewController <UITextFieldDelegate,CCTalkListener,CCActionDelegate>
{
    
}

@property (nonatomic, strong) NSString *myCallId;

@property (nonatomic, strong) NSString *peerCallId;


@end

