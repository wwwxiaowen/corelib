/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface EMTextView : UITextView
{
    UIColor *_contentColor;
    BOOL _editing;
}

@property(strong, nonatomic) NSString *placeholder;
@property(strong, nonatomic) UIColor *placeholderColor;

@end

/*

 - (EMTextView *)textView
 {
 if (_textView == nil) {
 _textView = [[EMTextView alloc] initWithFrame:CGRectMake(10, 70, 300, 80)];
 _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
 _textView.layer.borderWidth = 0.5;
 _textView.layer.cornerRadius = 3;
 _textView.font = [UIFont systemFontOfSize:14.0];
 _textView.backgroundColor = [UIColor whiteColor];
 _textView.placeholder = NSLocalizedString(@"group.create.inputDescribe", @"please enter a group description");
 _textView.returnKeyType = UIReturnKeyDone;
 _textView.delegate = self;
 }
 
 return _textView;
 }
 
*/