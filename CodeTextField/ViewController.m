//
//  ViewController.m
//  CodeTextField
//
//  Created by admin on 2020/9/23.
//  Copyright © 2020 min. All rights reserved.
//

#import "ViewController.h"
#import "ZMValideCodeTextField.h"

@interface ViewController ()

/// <#Description#>
@property (nonatomic, strong)  ZMValideCodeTextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenH = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    _textField = [[ZMValideCodeTextField alloc] initWithFrame:CGRectMake((screenW - 200) / 2.0, (screenH - 70) / 2.0, 200, 70)
                                                   codeLength:4];
    [self.view addSubview:_textField];
}


@end
