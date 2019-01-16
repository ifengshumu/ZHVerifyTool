//
//  ViewController.m
//  ZHVerifyTool
//
//  Created by Lee on 2018/10/11.
//  Copyright © 2018年 leezhihua All rights reserved.
//

#import "ViewController.h"
#import "ZHVerifyTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BOOL isPhone = [ZHVerifyTool verifyValue:@"16688992957" type:VerifyTypePhone];
    NSLog(@"%d", isPhone);
}


@end
