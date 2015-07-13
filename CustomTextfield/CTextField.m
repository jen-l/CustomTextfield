//
//  CTextField.m
//  CustomTextfield
//
//  Created by Jenelle Walker on 8/20/14.
//  Copyright (c) 2014 Jenelle Walker. All rights reserved.
//

#import "CTextField.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CTextField ()

@property (strong, nonatomic) UIImageView *underlineView;

@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) NSLayoutConstraint *textFieldConstraintsV;
@property (strong, nonatomic) NSLayoutConstraint *textFieldConstraintsH;
@property (strong, nonatomic) UIColor *originalTextColor;
@property (strong, nonatomic) UIColor *originalBorderColor;

@property (strong, nonatomic) UIImage *underlineImage;
@property (strong, nonatomic) UIImage *errorUnderlineImage;

@property (strong, nonatomic) UIColor *errorColor;
@property (strong, nonatomic) UIColor *errorUnderlineColor;

@property (nonatomic) CGFloat errorPadding;

@end

@implementation CTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.errorPadding = 0;
    self.originalFieldRect = self.frame;
    self.originalTextColor = self.textColor;
    self.originalBorderColor = (__bridge UIColor *)(self.layer.borderColor);
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self setClipsToBounds:NO];
    self.underlineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    [self.underlineView setAutoresizingMask:UIViewAutoresizingNone];
    [self.underlineView setContentMode:UIViewContentModeTop];
    [self.underlineView setClipsToBounds:YES];
    [self.underlineView setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.underlineView.center.x - self.underlineView.frame.size.width / 3, self.underlineView.frame.size.height + self.underlineView.frame.origin.y, self.frame.size.width / 1.25, 0)];
    self.errorLabel.center = CGPointMake(self.underlineView.center.x, self.errorLabel.center.y);
    
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.errorLabel];
    
    [self addSubview:self.underlineView];
    self.fieldHeight = self.originalFieldRect.size.height;

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setUpdatedConstraints];
    self.errorLabel.isAccessibilityElement = YES;
    self.isAccessibilityElement = YES;
    
    self.originalAccessibilityHint = self.accessibilityHint;
    
    [self addObserver:self forKeyPath:@"hasError" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.errorColor = [UIColor redColor];
    self.errorUnderlineColor = [UIColor redColor];
    [self bringSubviewToFront:self.errorLabel];
}

- (void) setMessageAlignment:(CMessageAlignment) alignment
{
    assert(self.underlineImage != nil);
    switch (alignment) {
        case CMessageAlignmentCenter:
            self.errorLabel.center = CGPointMake(self.underlineView.center.x,  self.underlineView.frame.size.height + self.underlineView.frame.origin.y + self.errorPadding);
            self.errorLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case CMessageAlignmentRight:
            self.errorLabel.frame = CGRectMake(self.underlineView.frame.origin.x + (self.underlineView.frame.size.width - self.errorLabel.frame.size.width), self.errorLabel.frame.origin.y, self.errorLabel.frame.size.width, self.errorLabel.frame.size.height);
            self.errorLabel.textAlignment = NSTextAlignmentRight;
            break;
        case CMessageAlignmentLeft:
            self.errorLabel.frame = CGRectMake(self.underlineView.frame.origin.x, self.errorLabel.frame.origin.y, self.errorLabel.frame.size.width, self.errorLabel.frame.size.height);
            self.errorLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case CMessageAlignmentOverCenter:
            self.errorLabel.center = CGPointMake(self.underlineView.center.x, self.underlineView.frame.origin.y);
            self.errorLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case CMessageAlignmentOverRight:
            self.errorLabel.frame = CGRectMake(self.underlineView.frame.origin.x + (self.underlineView.frame.size.width - self.errorLabel.frame.size.width), self.underlineView.frame.origin.y, self.errorLabel.frame.size.width, self.errorLabel.frame.size.height);
            self.errorLabel.textAlignment = NSTextAlignmentRight;
            break;
        case CMessageAlignmentOverLeft:
            self.errorLabel.frame = CGRectMake(self.underlineView.frame.origin.x, self.underlineView.frame.origin.y, self.errorLabel.frame.size.width, self.errorLabel.frame.size.height);
            self.errorLabel.textAlignment = NSTextAlignmentLeft;
            break;
        default:
            self.errorLabel.textAlignment = NSTextAlignmentCenter;
            break;
    }
}

- (void) setMessageColor:(UIColor *) color
{
    self.errorColor = color;
}

- (void) setUnderlineErrorColor:(UIColor *) color
{
    self.errorUnderlineColor = color;
}

- (void) setMessageFont:(UIFont *) font
{
    self.errorLabel.font = font;
}

- (void) setMessageDropShadowColor:(UIColor *) color
{
    [self.errorLabel setShadowColor:color];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"hasError"]) {
        [self underlineToggle:[change objectForKey:@"new"]];
    }
}

- (void) underlineToggle:(BOOL) hasError {
    if(!self.underlineImage && !self.errorUnderlineImage) {
        NSLog(@"Set underlineimage, errorunderlineimage or both");
        return;
    }
    
    if(hasError) {
        if(self.errorUnderlineImage) {
            self.underlineView.image = self.errorUnderlineImage;
        } else {
            self.underlineView.image = [self.underlineImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.underlineView setTintColor:self.errorUnderlineColor];
        }
    } else {
        if(self.errorUnderlineImage) {
            self.underlineView.image = self.underlineView.image;
        }  else {
            self.underlineView.image = [self.underlineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect r = [super placeholderRectForBounds:bounds];
    r.size.height = self.originalFieldRect.size.height;
    r.origin.y = -r.size.height + self.originalFieldRect.size.height;
    return r;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect r = [super textRectForBounds:bounds];
    r.size.height = self.originalFieldRect.size.height;
    r.origin.y = -r.size.height + self.originalFieldRect.size.height;
    
    return r;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect r = [super editingRectForBounds:bounds];

    return r;
}

-(CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect r = [super clearButtonRectForBounds:bounds];
    r.size.height = self.originalFieldRect.size.height;
    r.origin.y = -r.size.height + self.originalFieldRect.size.height;
    return r;
}

- (void) setErrorUnderlineImage:(UIImage*)errorUnderline {
    self.errorUnderlineImage = errorUnderline;
}

- (void) setTextfieldUnderlineImage:(UIImage*)underline {
    [self setBackground:nil];
    self.underlineImage = underline;
    [self.underlineView setContentMode:UIViewContentModeScaleToFill];
    CGRect newImageRect = AVMakeRectWithAspectRatioInsideRect(self.underlineImage.size, self.originalFieldRect);
    [self.underlineView setBounds:CGRectMake(0, 0, self.originalFieldRect.size.width, newImageRect.size.height)];
    self.errorPadding = self.underlineView.frame.size.height / 3;
    self.fieldHeight = self.originalFieldRect.size.height + newImageRect.size.height - 1;
    [self.underlineView setImage:self.underlineImage];
    [self setUpdatedConstraints];
}

+ (void) setAllTextfieldsUnderlineImage:(UIImage*)underline forViewController:(UIViewController *)controller {
    NSPredicate *textfieldSubviews = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[self class]];
    }];
    [[controller.view.subviews filteredArrayUsingPredicate:textfieldSubviews] makeObjectsPerformSelector:@selector(setTextfieldUnderlineImage:) withObject:underline];
}

- (void) setHasValidationErrorWithCustomString:(NSString *)errorString {
    [self underlineToggle:YES];
    if(errorString.length > 0) {
        self.errorLabel.text = errorString;

        self.errorLabel.numberOfLines = 0;
        CGSize maxSize = CGSizeMake(self.errorLabel.frame.size.width, CGFLOAT_MAX);
        CGSize desiredSize = [self.errorLabel sizeThatFits:maxSize];
        self.errorLabel.frame = CGRectMake(self.errorLabel.frame.origin.x, self.errorLabel.frame.origin.y, self.errorLabel.frame.size.width, desiredSize.height);
        
        [self.errorLabel setTextColor:self.errorColor];
        
        self.fieldHeight = self.originalFieldRect.size.height + self.underlineView.frame.size.height + self.errorLabel.frame.size.height - 1;
        
    } else {
        self.fieldHeight = self.originalFieldRect.size.height + self.underlineView.frame.size.height - 1;
    }

    [self setUpdatedConstraints];
}

- (void) setHasNoError
{
    [self underlineToggle:NO];
    self.textColor = self.originalTextColor;
    self.fieldHeight = self.fieldHeight - self.errorLabel.frame.size.height;
    self.errorLabel.frame = CGRectMake(self.errorLabel.frame.origin.x, self.errorLabel.frame.origin.y, self.errorLabel.frame.size.width, 0);
    self.errorLabel.isAccessibilityElement = NO;
    self.errorLabel.text = nil;
    [self setUpdatedConstraints];
    self.accessibilityHint = self.originalAccessibilityHint;
}

- (void) setUnderlineForError:(BOOL)hasError
{
    if(hasError) {
        self.fieldHeight = self.originalFieldRect.size.height + self.underlineView.frame.size.height + self.errorLabel.frame.size.height - 1;
    } else {
        self.fieldHeight = self.originalFieldRect.size.height + self.underlineView.frame.size.height + self.errorLabel.frame.size.height - 1;
    }
    [self setUpdatedConstraints];
}

- (void) setUpdatedConstraints
{
    UIImageView *underlineView = self.underlineView;
    UILabel *errorView = self.errorLabel;
    CTextField *textfield = self;
    [self removeConstraint:self.textFieldConstraintsV];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(textfield, underlineView, errorView);
    self.textFieldConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[textfield(%f)]-(%f)-[underlineView]-(%f)-[errorView(%f)]", self.fieldHeight, self.originalFieldRect.size.height - self.fieldHeight, self.underlineView.frame.size.height + self.underlineView.frame.origin.y + self.errorPadding, self.errorLabel.frame.size.height] options:0 metrics:nil views:viewsDictionary][0];
    self.textFieldConstraintsH = [NSLayoutConstraint constraintWithItem:underlineView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:textfield
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.f constant:0.f];
    [self addConstraints:@[self.textFieldConstraintsV, self.textFieldConstraintsH]];
}

- (void) focusOnSelf
{
    if( UIAccessibilityIsVoiceOverRunning() && NO == self.accessibilityElementIsFocused)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification,self);
        });
    }
}

@end
