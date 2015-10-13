//
//  KL_ImagesZoomController.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidChangeBrowsePhotoBlock)(NSInteger index,NSInteger photoCount);

@interface KL_ImagesZoomController : UIView<UITableViewDelegate,UITableViewDataSource>{
    DidChangeBrowsePhotoBlock indexBlock;
    NSInteger currentIndex;
}
@property (nonatomic, retain)NSMutableArray *imgs;
- (id)initWithFrame:(CGRect)frame;
- (void)updateImageDate:(NSMutableArray *)imageArr selectIndex:(NSInteger)index;
- (void)updateBrowsePhotoIndex:(DidChangeBrowsePhotoBlock)block;
- (void)updateTableViewImageData;
@end
