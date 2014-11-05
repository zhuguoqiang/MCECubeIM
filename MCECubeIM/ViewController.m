//
//  ViewController.m
//  MCECubeIM
//
//  Created by 朱国强 on 14-10-20.
//  Copyright (c) 2014年 MCECube. All rights reserved.
//

#import "ViewController.h"
#import "config.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tfPeer;
@property (strong, nonatomic) IBOutlet UITextField *tfSelf;
@property (strong, nonatomic) IBOutlet UIButton *btSend;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
//        self.myCallId = @"500";
//        self.peerCallId = @"501";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        self.myCallId = @"500";
//        self.peerCallId = @"501";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [CCTalkService sharedSingleton].listener = self;
    
    // 连接IM服务器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       // 连接 Cellet 服务
                       CCInetAddress *address = [[CCInetAddress alloc] initWithAddress:IM_SERVER_HOST port:IM_SERVER_PORT];
                       [[CCTalkService sharedSingleton] call:@"IM" hostAddress:address];
                   });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[CCTalkService sharedSingleton] hangUp:@"IM"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    else
    {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


- (IBAction)btnSendAction:(id)sender {
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:self.tfSelf.text,@"text", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.myCallId,@"myName",self.peerCallId,@"peerName",textDic,@"meta", nil];
    
    NSString *value = @"";
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }

//    NSString *sharedJSON = [NSString stringWithFormat:@"{\"myName\":\"%@\", \"peerName\":\"%@\", \"meta\":%@}"
//                            , self.myCallId, self.peerCallId, value];
    
    CCActionDialect *dialect = [[CCActionDialect alloc] initWithAction:@"shareMeta"];
    [dialect appendParam:@"data" stringValue:value];
    [[CCTalkService sharedSingleton] talk:@"IM" dialect:dialect];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        
    }else if (textField.tag == 200)
    {
        
    }
}

#pragma mark Talk Listener

- (void)dialogue:(NSString *)identifier primitive:(CCPrimitive *)primitive
{
    @synchronized(self) {
        if ([primitive isDialectal])
        {
            CCActionDialect *dialect = (CCActionDialect *) primitive.dialect;
            NSString *action = dialect.action;
            NSString *strJSON = [dialect getParamAsString:@"data"];
            NSData *data = [strJSON dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([action isEqualToString:@"shareMeta"])
            {
                // 绘制 Meta
                NSDictionary *metaJson = [json objectForKey:@"meta"];
                NSString *text = [metaJson objectForKey:@"text"];
//                NSString *from = [json objectForKey:@"from"];
                
                [self.tfPeer setText:[NSString stringWithFormat:@"%@",text]];
                
            }
        }
}
}

- (void)contacted:(NSString *)identifier tag:(NSString *)tag
{
    // 进行注册
    CCActionDialect *dialect = [[CCActionDialect alloc] initWithAction:@"register"];
    NSString *value = [NSString stringWithFormat:@"{\"name\":\"%@\"}", self.myCallId];
    [dialect appendParam:@"data" stringValue:value];
    [[CCTalkService sharedSingleton] talk:@"IM" dialect:dialect];
}

- (void)quitted:(NSString *)identifier tag:(NSString *)tag
{
}

- (void)failed:(CCTalkServiceFailure *)failure
{
    NSLog(@"CC Failed: %@", failure.description);
    
    // 连接服务器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       // 连接 Cellet 服务
                       CCInetAddress *address = [[CCInetAddress alloc] initWithAddress:IM_SERVER_HOST port:IM_SERVER_PORT];
                       [[CCTalkService sharedSingleton] call:@"IM" hostAddress:address];
                   });
    
}


#pragma mark Action Delegate

- (void)doAction:(CCActionDialect *)dialect
{
    [CCLogger d:@"Do action '%@' - identifier=%@ tag=%@ (thread:%@)"
     , dialect.action
     , dialect.celletIdentifier
     , dialect.ownerTag
     , [NSThread currentThread]];
}


@end
