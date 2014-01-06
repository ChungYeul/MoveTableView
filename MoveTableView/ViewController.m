//
//  ViewController.m
//  MoveTableView
//
//  Created by In Chung Yeul on 2014. 1. 6..
//  Copyright (c) 2014년 In Chung Yeul. All rights reserved.
//

#import "ViewController.h"
#define CELL_ID @"CELL_ID"
@interface ViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userInput;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController {
    NSMutableArray *data;
}
// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    return cell;
}

// 셀 편집 승인 작업 작성
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Core Logic
        [data removeObjectAtIndex:indexPath.row];
        
        // UI Logic
        NSArray *rows = [NSArray arrayWithObject:indexPath];
        [self.table deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 셀 이동, Non-ARC 환경에서는 리테인카운트 주의
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSObject *obj = [data objectAtIndex:sourceIndexPath.row];
    [data removeObjectAtIndex:sourceIndexPath.row];
    [data insertObject:obj atIndex:destinationIndexPath.row];
}
// 새 데이터추가 - 셀 반영
- (IBAction)addItem:(id)sender {
    NSString *inputStr = self.userInput.text;
    if ([inputStr length] > 0) {
        // 데이터 추가(Core Logic)
        [data addObject:inputStr];
        
        // 테이블에 셀 추가(UI Logic)
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([data count] - 1) inSection:0];
        NSArray *row = [NSArray arrayWithObject:indexPath];
        [self.table insertRowsAtIndexPaths:row withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    // 텍스트필드 초기화
    self.userInput.text = @"";
}

// 편집상태를 토글식 전환
- (IBAction)toggleEditMode:(id)sender {
    self.table.editing = !self.table.editing;
    ((UIBarButtonItem *)sender).title = self.table.editing ? @"Done" : @"Edit";
}

// 텍스트 필드에서 리턴키로 추가하기
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self addItem:nil];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
