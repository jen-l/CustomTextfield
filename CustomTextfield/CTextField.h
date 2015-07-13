//
//  CTextField.h
//  CustomTextfield
//
//  Created by Jenelle Walker on 8/20/14.
//  Copyright (c) 2014 Jenelle Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CMessageAlignment) {
    CMessageAlignmentCenter = 0,
    CMessageAlignmentRight,
    CMessageAlignmentLeft,
    CMessageAlignmentOverCenter,
    CMessageAlignmentOverRight,
    CMessageAlignmentOverLeft
};

@interface CTextField : UITextField

@property (nonatomic) CGFloat fieldHeight;
@property (nonatomic) CGRect originalFieldRect;
@property (strong, nonatomic) NSString * originalAccessibilityHint;
@property (strong, nonatomic) UILabel *errorLabel;

- (void) setHasValidationErrorWithCustomString:(NSString *)errorString;
- (void) setHasNoError;
- (void) setUnderlineForError:(BOOL)hasError;
- (void) setErrorUnderlineImage:(UIImage*)errorUnderline;
- (void) setTextfieldUnderlineImage:(UIImage*)underline;
+ (void) setAllTextfieldsUnderlineImage:(UIImage*)underline forViewController:(UIViewController *)controller;
- (void) focusOnSelf;
- (void) setMessageAlignment:(CMessageAlignment) alignment;
- (void) setMessageColor:(UIColor *) color;
- (void) setUnderlineErrorColor:(UIColor *) color;
- (void) setMessageFont:(UIFont *) font;
- (void) setMessageDropShadowColor:(UIColor *) color;

@end
