 
//创建富文本容器
- (TYTextContainer *)creatTextContainer
{
    NSString *text = @"@青春励志: [haha,15,15]其实所有漂泊的人 2015-10-14 10:25，[haha,15,15]不过是为了有一天能够不再漂泊，[haha,15,15][avatar,15,15]能用自己的力量撑起身后的家人和自己爱的人。 [avatar,15,15]#青春励志#[button][avatar,15,15]能用自己的力量撑起身后的家2015年10月14日14时15分人和自己爱的人。";
    
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // 正则匹配图片信息 需要引入RegexKitLite正则库
    [text enumerateStringsMatchedByRegex:@"(\\d{1,4}[-|年]\\d{1,2}[-|月]\\d{1,2}([日|号])?(\\s)*(\\d{1,2}([点|时])?((:)?\\d{1,2}(分)?)?)?)" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 8) { 
            TYLinkTextStorage *linkTextStorage = [[TYLinkTextStorage alloc]init];
            linkTextStorage.range = capturedRanges[0];
            linkTextStorage.textColor = [UIColor greenColor];
            linkTextStorage.linkData = capturedStrings[1];
            linkTextStorage.underLineStyle = kCTUnderlineStyleSingle;
//            // 图片信息储存
//            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
//            imageStorage.imageName = capturedStrings[1];
//            imageStorage.range = capturedRanges[0];
//            imageStorage.size = CGSizeMake([capturedStrings[2]intValue], [capturedStrings[3]intValue]);
            
            [tmpArray addObject:linkTextStorage];
        }
    }];
      
    
    // 添加图片信息数组到label
    [textContainer addTextStorageArray:tmpArray];
    
    [textContainer addLinkWithLinkData:@"点击了@青春励志" linkColor:nil underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:@"@青春励志"]];
    
    [textContainer addLinkWithLinkData:@"点击了#青春励志#" linkColor:nil underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:@"#青春励志#"]];
    
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];
    textStorage.range = [text rangeOfString:@"[CYLoLi,320,180]其实所有漂泊的人，"];
    textStorage.textColor = RGB(213, 0, 0, 1);
    textStorage.font = [UIFont systemFontOfSize:16];
    [textContainer addTextStorage:textStorage];
    
    textStorage = [[TYTextStorage alloc]init];
    textStorage.range = [text rangeOfString:@"不过是为了有一天能够不再漂泊，"];
    textStorage.textColor = RGB(0, 155, 0, 1);
    textStorage.font = [UIFont systemFontOfSize:18];
    [textContainer addTextStorage:textStorage];
  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 2;
    [button setBackgroundColor:[UIColor redColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitle:@"UIButton" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 60, 15);
    [textContainer addView:button range:[text rangeOfString:@"[button]"]];
    textContainer.linesSpacing = 2;
    textContainer = [textContainer createTextContainerWithTextWidth:CGRectGetWidth(self.view.frame)-40];//自动生成高度
    return textContainer;
}

//在tableviewcell中
- (void)layoutSubviews{
    [super layoutSubviews]; 
    
    [_label setFrameWithOrign:CGPointMake(0, 15) Width:CGRectGetWidth(self.frame)]; //自动适应渲染高度
    
    // or this use
    //_label.frame = CGRectMake(0, 15, CGRectGetWidth(self.frame), 0);
    //[_label sizeToFit];     //自动适应渲染高度
}


//赋值
cell.label.textContainer = _textContainers[indexPath.row];


//回调
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    NSLog(@"textStorageClickedAtPoint");
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) { 
        id linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }else if ([TextRun isKindOfClass:[TYImageStorage class]]) {
        TYImageStorage *imageStorage = (TYImageStorage *)TextRun;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:[NSString stringWithFormat:@"你点击了%@图片",imageStorage.imageName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

// 长按代理 有多个状态 begin, changes, end 都会调用,所以需要判断状态
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageLongPressed:(id<TYTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point{
}





 
