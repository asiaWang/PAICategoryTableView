//
//  PAICategoryCell.h
//  PAICategoryViewController
//
//  Created by bo on 16/4/12.
//  Copyright © 2016年 com.pencho.com. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PAICategoryCellType) {
    PAICategoryCellType_FirstLevel,
    PAICategoryCellType_SecondLevel,
    PAICategoryCellType_ThirdLevel,
};

@interface PAICategoryCell : UITableViewCell
@property (nonatomic,assign,readonly)PAICategoryCellType categoryCellType;
- (void)setCategoryCellLevels:(PAICategoryCellType)level selected:(BOOL)selected context:(NSString *)context contextImage:(NSString *)contextImageUrl;
@end
