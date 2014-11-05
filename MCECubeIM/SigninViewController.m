//
//  SigninViewController.m
//  MCECubeIM
//
//  Created by 朱国强 on 14-10-20.
//  Copyright (c) 2014年 MCECube. All rights reserved.
//

#import "SigninViewController.h"
#import "ViewController.h"

@interface SigninViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tfMyCall;
@property (strong, nonatomic) IBOutlet UITextField *tfPeerCall;
@property (strong, nonatomic) IBOutlet UIButton *btnSign;

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSigninAction:(id)sender
{
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    viewController.myCallId = self.tfMyCall.text;
    viewController.peerCallId = self.tfPeerCall.text;
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == 10) {
        
    }else if (textField.tag == 20)
    {
        
    }
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
