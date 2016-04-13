//
//  PAICategoryCell.m
//  PAICategoryViewController
//
//  Created by bo on 16/4/12.
//  Copyright © 2016年 com.pencho.com. All rights reserved.
//

#import "PAICategoryCell.h"

@interface PAICategoryCell()
@property (strong, nonatomic)  UIImageView *imaeHeadView;
@property (strong, nonatomic)  UILabel *categoryContextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageContextView;
@property (nonatomic,assign,readwrite)PAICategoryCellType categoryCellType;

@end

@implementation PAICategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imaeHeadView = [[UIImageView alloc] init];
    self.imaeHeadView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.imaeHeadView];
    
    self.categoryContextLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.categoryContextLabel];
}

- (void)setCategoryCellLevels:(PAICategoryCellType)level selected:(BOOL)selected context:(NSString *)context contextImage:(NSString *)contextImageUrl {
    self.categoryCellType = level;
    self.categoryContextLabel.text = context;
    
    switch (self.categoryCellType) {
        case PAICategoryCellType_FirstLevel:{
            self.imaeHeadView.frame = CGRectMake(25, self.contentView.frame.size.height / 2 - 11, 22, 22);
            self.categoryContextLabel.frame = CGRectMake(self.imaeHeadView.frame.origin.x +  self.imaeHeadView.frame.size.width + 15, self.contentView.frame.size.height / 2 - 20, 160, 40);
            if (selected) {
                [self.imaeHeadView setImage:[UIImage imageNamed:@""]];
            }else {
                [self.imaeHeadView setImage:[UIImage imageNamed:@""]];
            }
        }
            break;
        case PAICategoryCellType_SecondLevel:{
            self.imaeHeadView.frame = CGRectMake(25 + 22, self.contentView.frame.size.height / 2 - 11, 22, 22);
            self.categoryContextLabel.frame = CGRectMake(self.imaeHeadView.frame.origin.x + self.imaeHeadView.frame.size.width + 15, self.contentView.frame.size.height / 2 - 20, 160, 40);
            if (selected) {
                [self.imaeHeadView setImage:[UIImage imageNamed:@""]];
            }else {
                [self.imaeHeadView setImage:[UIImage imageNamed:@""]];
            }
        }
            break;
        case PAICategoryCellType_ThirdLevel:{
            self.imaeHeadView.frame = CGRectMake(25 + 44, self.contentView.frame.size.height / 2 - 11, 22, 22);
            self.categoryContextLabel.frame = CGRectMake(self.imaeHeadView.frame.origin.x + self.imaeHeadView.frame.size.width + 15, self.contentView.frame.size.height / 2 - 20, 160, 40);
            if (selected) {
                [self.imaeHeadView setImage:[UIImage imageNamed:@""]];
            }else {
                [self.imaeHeadView setImage:nil];
            }
        }
            break;
        default:
            break;
    }
    
//    switch (self.categoryCellType) {
//        case PAICategoryCellType_FirstLevel:
//            
//            break;
//        case PAICategoryCellType_SecondLevel:
//            break;
//        case PAICategoryCellType_ThirdLevel:
//            break;
//        default:
//            break;
//    }
    if (selected) {
        self.imaeHeadView.backgroundColor = [UIColor redColor];
    }else {
        self.imaeHeadView.backgroundColor = [UIColor greenColor];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
