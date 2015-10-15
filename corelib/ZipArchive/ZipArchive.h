//
//  ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "minizip/zip.h"
#include "minizip/unzip.h"


@protocol ZipArchiveDelegate <NSObject>
@optional
-(void) ErrorMessage:(NSString*) msg;
-(BOOL) OverWriteOperation:(NSString*) file;

@end


@interface ZipArchive : NSObject {
@private
	zipFile		_zipFile;
	unzFile		_unzFile;
	
	NSString*   _password;
	id			_delegate;
}

@property (nonatomic, retain) id delegate;

-(BOOL) CreateZipFile2:(NSString*) zipFile;
-(BOOL) CreateZipFile2:(NSString*) zipFile Password:(NSString*) password;
-(BOOL) addFileToZip:(NSString*) file newname:(NSString*) newname;
-(BOOL) CloseZipFile2;

-(BOOL) UnzipOpenFile:(NSString*) zipFile;
-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password;
-(BOOL) UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite;
-(BOOL) UnzipCloseFile;
@end

//libz.1.2.5.dylib
//-fno-objc-arc

////下载并解压解压文件处理 urlpath = @"http://192.168.1.41:8089/resources/pages/zipfile.zip"
//- (void)upzip:(NSString *)urlpath{
//    dispatch_queue_t queue = dispatch_get_global_queue(
//                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSURL *url = [NSURL URLWithString:urlpath];
//        NSError *error = nil;
//        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
//        
//        if(!error) {
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString *path = [paths objectAtIndex:0];
//            NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
//            
//            [data writeToFile:zipPath options:0 error:&error];
//            if(!error) {
//                ZipArchive *za = [[ZipArchive alloc] init];
//                if ([za UnzipOpenFile: zipPath]) {
//                    BOOL ret = [za UnzipFileTo: path overWrite: YES];
//                    if (NO == ret){} [za UnzipCloseFile];
//                    
//                    //解压完成
//                    NSString *imageFilePath = [path stringByAppendingPathComponent:@"www/index2015.html"];
//                    NSString *textString = [NSString stringWithContentsOfFile:imageFilePath encoding:NSASCIIStringEncoding error:nil];
//                    //渲染
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.web loadHTMLString:textString baseURL:nil];
//                    });
//                }
//            } else {
//                NSLog(@"Error saving file %@",error);
//            }
//        } else {
//            NSLog(@"Error downloading zip file: %@", error);
//        }
//    });
//}
//
////压缩文件处理
//- (void)zipFiles
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docspath = [paths objectAtIndex:0];
//    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [paths objectAtIndex:0];
//    
//    NSString *zipFile = [docspath stringByAppendingPathComponent:@"newzipfile.zip"];
//    
//    ZipArchive *za = [[ZipArchive alloc] init];
//    [za CreateZipFile2:zipFile];
//    
//    NSString *imagePath = [cachePath stringByAppendingPathComponent:@"photo.png"];
//    NSString *textPath = [cachePath stringByAppendingPathComponent:@"text.txt"];
//    
//    [za addFileToZip:imagePath newname:@"NewPhotoName.png"];
//    [za addFileToZip:textPath newname:@"NewTextName.txt"];
//    
//    BOOL success = [za CloseZipFile2];
//    NSLog(@"Zipped file with result %d",success);
//}
