//
//  ViewController.m
//  PAICategoryViewController
//
//  Created by bo on 16/4/12.
//  Copyright © 2016年 com.pencho.com. All rights reserved.
//

#import "PAICategoryViewController.h"
#import "PAICategoryCell.h"

typedef NS_ENUM(NSInteger,PAICategoryViewSelectedType) {
    PAICategoryViewSelectedType_None,
    PAICategoryViewSelectedType_FirstLevel,
    PAICategoryViewSelectedType_SecondLevel,
    PAICategoryViewSelectedType_ThirdLevel,
};


@interface PAICategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSArray *firstLevelTitle;
@property (nonatomic,assign)PAICategoryViewSelectedType selectedType;

@property (nonatomic,assign)NSInteger tabelViewCount;
@property (nonatomic,assign)NSInteger firstLevelSelectedCount;
@property (nonatomic,assign)NSInteger secondLevelSelectedCount;
@property (nonatomic,assign)NSInteger thirdLevelSelectedCount;

@property (nonatomic,strong)NSIndexPath *selectedIndexPath;
@end

@implementation PAICategoryViewController


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *array0 = @[@"男装",@"女装",@"美妆",@"彩妆"];
    NSArray *array1 = @[@"皮鞋",@"凉鞋",@"平底鞋",@"滑板鞋",@"棉鞋"];
    NSArray *array2 = @[@"针织衫",@"卫衣",@"T恤",@"衬衫",@"上衣"];
    NSArray *array3 = @[@"鞋子",@"上装"];
    
    self.data = [NSMutableArray array];
    self.firstLevelTitle = [NSArray arrayWithArray:array0];
    self.firstLevelSelectedCount = -1;
    self.secondLevelSelectedCount = -1;
    self.thirdLevelSelectedCount = -1;
    self.selectedType = PAICategoryViewSelectedType_None;

    for (int i = 0; i < array0.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int j = 0; j < array3.count; j++) {
            if (j == 0) {
                [dict setObject:array1 forKey:array3[0]];
            }else {
                [dict setObject:array2 forKey:array3[1]];
            }
        }
        [self.data addObject:[NSDictionary dictionaryWithDictionary:dict]];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedType == PAICategoryViewSelectedType_None) {
        self.tabelViewCount = self.data.count;
    }else if (self.selectedType == PAICategoryViewSelectedType_FirstLevel) {
        self.tabelViewCount = self.data.count;
    }else if (self.selectedType == PAICategoryViewSelectedType_SecondLevel) {
        NSDictionary *dict = self.data[self.firstLevelSelectedCount];
        self.tabelViewCount = self.data.count + dict.count;
    }else {
        NSDictionary *dict = self.data[self.firstLevelSelectedCount];
        NSString *key = [[dict allKeys]objectAtIndex:(self.secondLevelSelectedCount)];
        NSArray *array = dict[key];
        self.tabelViewCount = self.data.count + dict.count + array.count;
    }
    return self.tabelViewCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIndetify = @"PAICategoryIndentify";
    PAICategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIndetify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PAICategoryCell" owner:nil options:nil]lastObject];
    }
    if (self.firstLevelSelectedCount == -1) {
        [cell setCategoryCellLevels:PAICategoryCellType_FirstLevel selected:NO context:self.firstLevelTitle[indexPath.row] contextImage:nil];
    }else {
        NSDictionary *dict = self.data[self.firstLevelSelectedCount];
        if (self.secondLevelSelectedCount == -1) {
            // 表示第二级页面没有打开
            if (indexPath.row <= self.firstLevelSelectedCount || indexPath.row > self.firstLevelSelectedCount + dict.count) {
                if (indexPath.row <= self.firstLevelSelectedCount) {
                    if (indexPath.row == self.firstLevelSelectedCount) {
                        [cell setCategoryCellLevels:PAICategoryCellType_FirstLevel selected:YES context:self.firstLevelTitle[indexPath.row] contextImage:nil];
                    }else {
                        [cell setCategoryCellLevels:PAICategoryCellType_FirstLevel selected:NO context:self.firstLevelTitle[indexPath.row] contextImage:nil];
                    }
                }else {
                    [cell setCategoryCellLevels:PAICategoryCellType_FirstLevel selected:NO context:self.firstLevelTitle[indexPath.row - dict.count ] contextImage:nil];
                }
            }else {
                [cell setCategoryCellLevels:PAICategoryCellType_SecondLevel selected:NO context:[dict allKeys][indexPath.row - self.firstLevelSelectedCount -1] contextImage:nil];
            }
        }else {
            // 表示第三级页面打开
            NSString *key = [[dict allKeys]objectAtIndex:(self.secondLevelSelectedCount)];
            NSArray *array = dict[key];
            if (indexPath.row <= self.firstLevelSelectedCount || indexPath.row > self.firstLevelSelectedCount + dict.count + array.count) {
                // 第一级显示
                if (indexPath.row <= self.firstLevelSelectedCount) {
                    if (indexPath.row == self.firstLevelSelectedCount) {
                        [cell setCategoryCellLevels:PAICategoryCellType_FirstLevel selected:YES context:self.firstLevelTitle[indexPath.row] contextImage:nil];
                    }else {
                        [cell setCategoryCellLevels:PAICategoryCellType_FirstLevel selected:NO context:self.firstLevelTitle[indexPath.row] contextImage:nil];
                    }
                }else {
                    [cell setCategoryCellLevels:PAICategoryCellType_FirstLevel selected:NO context:self.firstLevelTitle[indexPath.row - dict.count - array.count ] contextImage:nil];
                }
            }else {
                NSInteger realSecondSelectedIndex = self.firstLevelSelectedCount + self.secondLevelSelectedCount + 1;
                if ( (indexPath.row > self.firstLevelSelectedCount && indexPath.row <= realSecondSelectedIndex) || indexPath.row > realSecondSelectedIndex + array.count) {
                    // 第二级显示
                    if (indexPath.row == realSecondSelectedIndex) {
                        [cell setCategoryCellLevels:PAICategoryCellType_SecondLevel selected:YES context:[dict allKeys][indexPath.row - self.firstLevelSelectedCount - 1] contextImage:nil];
                    }else {
                        if (indexPath.row > self.firstLevelSelectedCount && indexPath.row < realSecondSelectedIndex) {
                            [cell setCategoryCellLevels:PAICategoryCellType_SecondLevel selected:NO context:[dict allKeys][indexPath.row - self.firstLevelSelectedCount -1] contextImage:nil];
                        }else {
                            [cell setCategoryCellLevels:PAICategoryCellType_SecondLevel selected:NO context:[dict allKeys][indexPath.row - realSecondSelectedIndex - array.count ] contextImage:nil];
                        }
                    }
                }else {
                    // 第三级显示
                    if (self.thirdLevelSelectedCount == -1) {
                        [cell setCategoryCellLevels:PAICategoryCellType_ThirdLevel selected:NO context:array[indexPath.row - realSecondSelectedIndex -1] contextImage:nil];
                    }else {
                        if (indexPath.row == self.thirdLevelSelectedCount) {
                            [cell setCategoryCellLevels:PAICategoryCellType_ThirdLevel selected:YES context:array[indexPath.row - realSecondSelectedIndex -1 ] contextImage:nil];
                        }else {
                            [cell setCategoryCellLevels:PAICategoryCellType_ThirdLevel selected:NO context:array[indexPath.row - realSecondSelectedIndex -1] contextImage:nil];
                        }
                    }
                }
            }
            
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 第一级选择只有一种情况,跳转到第二级
    if (self.selectedType == PAICategoryViewSelectedType_FirstLevel || self.selectedType == PAICategoryViewSelectedType_None) {
        if (self.firstLevelSelectedCount == indexPath.row) {
            self.firstLevelSelectedCount = -1;
            [self.tableView reloadData];
            return;
        }
        self.selectedType = PAICategoryViewSelectedType_SecondLevel;
        self.firstLevelSelectedCount = indexPath.row;
    }else {
        
        if (indexPath.row < self.firstLevelSelectedCount) {
            self.firstLevelSelectedCount = indexPath.row;
            self.secondLevelSelectedCount = -1;
            self.thirdLevelSelectedCount = -1;
            self.selectedType = PAICategoryViewSelectedType_SecondLevel;
            [self.tableView reloadData];
            return;
        }
        
        if (self.selectedType == PAICategoryViewSelectedType_SecondLevel) {
            NSDictionary *dict = self.data[self.firstLevelSelectedCount];
            if (indexPath.row == self.firstLevelSelectedCount || indexPath.row > self.firstLevelSelectedCount + dict.count) {
                self.secondLevelSelectedCount = -1;
                self.thirdLevelSelectedCount = -1;
                if (indexPath.row == self.firstLevelSelectedCount) {
                    self.selectedType = PAICategoryViewSelectedType_FirstLevel;
                    self.firstLevelSelectedCount = -1;
                }else {
                    self.selectedType = PAICategoryViewSelectedType_SecondLevel;
                    self.firstLevelSelectedCount = indexPath.row - dict.count ;
                }
                [self.tableView reloadData];
                return;
            }
            if ( self.firstLevelSelectedCount < indexPath.row && indexPath.row <= self.firstLevelSelectedCount + dict.count) {
                self.secondLevelSelectedCount = indexPath.row - self.firstLevelSelectedCount -1;
                self.thirdLevelSelectedCount = -1;
                self.selectedType = PAICategoryViewSelectedType_ThirdLevel;
                [self.tableView reloadData];
                return;
            }
        }
        if (self.selectedType == PAICategoryViewSelectedType_ThirdLevel) {
            NSDictionary *dict = self.data[self.firstLevelSelectedCount];
            NSString *key = [[dict allKeys]objectAtIndex:self.secondLevelSelectedCount];
            NSArray *array = dict[key];

            if (indexPath.row <= self.firstLevelSelectedCount || indexPath.row > self.firstLevelSelectedCount + dict.count + array.count) {
                self.secondLevelSelectedCount = -1;
                self.thirdLevelSelectedCount = -1;
                if (indexPath.row <= self.firstLevelSelectedCount) {
                    if (indexPath.row == self.firstLevelSelectedCount) {
                        self.firstLevelSelectedCount = -1;
                        self.selectedType = PAICategoryViewSelectedType_FirstLevel;
                    }else {
                        self.firstLevelSelectedCount = indexPath.row;
                        self.selectedType = PAICategoryViewSelectedType_SecondLevel;
                    }
                }else {
                    self.firstLevelSelectedCount = indexPath.row - dict.count - array.count;
                    self.selectedType = PAICategoryViewSelectedType_SecondLevel;
                }
                [self.tableView reloadData];
                return;
            }
            
            NSInteger realSecondSelectedIndex = self.firstLevelSelectedCount + self.secondLevelSelectedCount + 1;
            if (indexPath.row == realSecondSelectedIndex) {
                self.selectedType = PAICategoryViewSelectedType_SecondLevel;
                self.thirdLevelSelectedCount = -1;
                self.secondLevelSelectedCount = -1;
                [self.tableView reloadData];
                return;
            }
            
            // 点击选择二级分类
            if ((indexPath.row > self.firstLevelSelectedCount && indexPath.row < realSecondSelectedIndex) || (indexPath.row > realSecondSelectedIndex + array.count && indexPath.row <= self.firstLevelSelectedCount + dict.count + array.count)) {
                if (indexPath.row > self.firstLevelSelectedCount && indexPath.row < realSecondSelectedIndex) {
                    self.secondLevelSelectedCount = indexPath.row - self.firstLevelSelectedCount -1;
                }else {
                    self.secondLevelSelectedCount = indexPath.row - realSecondSelectedIndex - array.count;
                }
                self.thirdLevelSelectedCount = -1;
                [self.tableView reloadData];
                return;
            }
            
            if (indexPath.row > realSecondSelectedIndex && indexPath.row <= realSecondSelectedIndex + array.count) {
                self.thirdLevelSelectedCount = indexPath.row;
                [self.tableView reloadData];
                return;
            }
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
