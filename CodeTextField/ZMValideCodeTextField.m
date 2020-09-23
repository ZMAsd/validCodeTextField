//
//  ZMValideCodeTextField.m
//  yaha_ios
//
//  Created by admin on 2020/9/10.
//  Copyright © 2020 min. All rights reserved.
//

#import "ZMValideCodeTextField.h"

// 分割线的宽度
static const CGFloat kSeparatorLineWidth = 10;
static const CGFloat kTitleFont = 32;
static const CGFloat kBottomLineHeight = 4;

#define kClearColor [UIColor clearColor]
#define kTesterColor [UIColor redColor]

@interface ZMValideCodeTextField ()

/// <#Description#>
@property (nonatomic, assign)  NSUInteger codeLength;
/// <#Description#>
@property (nonatomic, assign)  CGFloat titleSeparatorW;
/// <#Description#>
@property (nonatomic, strong)  UILabel *foreLabel;
/// <#Description#>
@property (nonatomic, strong)  UIView *lineView;
/// <#Description#>
@property (nonatomic, assign)  NSUInteger shouldHideKeyBoard;

@end

@implementation ZMValideCodeTextField

- (instancetype)initWithFrame:(CGRect)frame codeLength:(NSUInteger)codeLength {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupSubViews];
        
        _codeLength = codeLength;
        // 计算出分割线的长度
        NSMutableString *string = [NSMutableString string];
        for (int i = 0; i < _codeLength; i++) {
            [string appendFormat:@"%d", 9];
        }
        // 计算分割的间距
        CGRect titleRect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kTitleFont]
        } context:nil];
        NSUInteger titleW = ceilf(CGRectGetWidth(titleRect));
        _titleSeparatorW = (CGRectGetWidth(frame) - titleW - kSeparatorLineWidth * (_codeLength - 1)) / (1.0 * _codeLength);
        // 注册通知
        [self p_registerNotification];
    }
    return self;
}

#pragma mark -- PrivateMethod
- (void)p_setupSubViews {
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.font = [UIFont boldSystemFontOfSize:kTitleFont];
    self.tintColor = kClearColor;
    self.textColor = kClearColor;
    
    // 显示text的前面板
    UILabel *foreLabel = [[UILabel alloc] initWithFrame:self.bounds];
    foreLabel.textColor = kTesterColor;
    foreLabel.font = [UIFont boldSystemFontOfSize:kTitleFont];
    [self addSubview:foreLabel];
    _foreLabel = foreLabel;
    
    [self addSubview:self.lineView];
    _lineView.hidden = true;
}

- (void)p_registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)drawRect:(CGRect)rect {
    /*
     
     - - - -
     
     */
    [super drawTextInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kBottomLineHeight);
    // 圆角虚线
    //    CGContextSetLineJoin(context, kCGLineJoinRound);
    //    CGContextSetLineCap(context, kCGLineCapRound);
    // 画虚线
    CGFloat itemH = CGRectGetHeight(rect);
    CGContextMoveToPoint(context, 0, itemH - kBottomLineHeight / 2.0);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), itemH - kBottomLineHeight / 2.0);
    CGFloat itemW = (CGRectGetWidth(rect) - kSeparatorLineWidth * (_codeLength - 1)) / (_codeLength * 1.0);
    CGFloat dash[] = {itemW, 10};
    CGContextSetLineDash(context, 0, dash, 2);
    
    CGContextSetFillColorWithColor(context, UIColor.orangeColor.CGColor);
    CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
    CGContextStrokePath(context);
}

#pragma mark -- NSNotification
- (void)textFieldTextChanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSString *title = textField.text;
    self.text = title;
}

- (void)keyBoardWillShow:(NSNotification *)notification {
    _lineView.hidden = false;
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    _lineView.hidden = true;
}

#pragma mark -- Setter
- (void)setText:(NSString *)text {
    [super setText:text];
    NSString *title = text;
    if (title.length >= 4) {
        _lineView.hidden = true;
        [self resignFirstResponder];
        _shouldHideKeyBoard = true;
    } else {
        _lineView.hidden = false;
    }
    if (title.length >= 0) {
        // 显示的文本
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < title.length; i++) {
            NSTextAttachment *att = [[NSTextAttachment alloc] init];
            att.image = [UIImage new];
            if (i == 0) {
                att.bounds = CGRectMake(0, 0, _titleSeparatorW / 2.0, 20);
                NSAttributedString *string0 = [NSAttributedString attributedStringWithAttachment:att];
                [string insertAttributedString:string0 atIndex:0];
            } else {
                att.bounds = CGRectMake(0, 0, _titleSeparatorW + kSeparatorLineWidth, 20);
                NSAttributedString *string0 = [NSAttributedString attributedStringWithAttachment:att];
                [string appendAttributedString:string0];
            }
            NSString *currentTitle = [title substringWithRange:NSMakeRange(i, 1)];
            NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:currentTitle];
            [string appendAttributedString:string1];
        }
        _foreLabel.attributedText = string;
    }
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:rect];
    
    if (_shouldHideKeyBoard) {
        _shouldHideKeyBoard = false;
    }
    NSUInteger textLength = self.text.length;
    CGFloat eachItemW = (CGRectGetWidth(self.bounds) - kSeparatorLineWidth * (_codeLength - 1)) / (_codeLength * 1.0);
    CGRect frame = self.lineView.frame;
    if (textLength == 0) {
        frame.origin.x = 0;
    } else {
        frame.origin.x = textLength * eachItemW + kSeparatorLineWidth * (textLength - 1) - CGRectGetWidth(frame);
    }
    _lineView.frame = frame;
}

#pragma mark -- Getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, CGRectGetHeight(self.frame) - kBottomLineHeight)];
        _lineView.backgroundColor = kTesterColor;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @1.0;
        animation.toValue = @0;
        animation.removedOnCompletion = false;
        animation.duration = 1.f;
        animation.repeatCount = CGFLOAT_MAX;
        animation.fillMode = kCAFillModeForwards;
        [_lineView.layer addAnimation:animation forKey:@"lineAnimation"];
    }
    return _lineView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


//        if (title.length > 0) {
//            // 显示的文本
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title];
//            for (int i = 1; i <= title.length; i++) {
//                NSTextAttachment *att = [[NSTextAttachment alloc] init];
//                if (i == 1) {
//                    att.bounds = CGRectMake(0, 0, _titleSeparatorW / 2.0, 20);
//                    NSAttributedString *string0 = [NSAttributedString attributedStringWithAttachment:att];
//                    [string insertAttributedString:string0 atIndex:0];
//                } else {
//                    att.bounds = CGRectMake(0, 0, _titleSeparatorW, 20);
//                    NSAttributedString *string0 = [NSAttributedString attributedStringWithAttachment:att];
//                    [string appendAttributedString:string0];
//                }
//            }
//            self.attributedText = string;
//        }
