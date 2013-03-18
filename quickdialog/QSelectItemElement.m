//
//  QSelectItemElement.m
//  QuickDialog
//
//  Created by HiveHicks on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QSelectItemElement.h"

@implementation QSelectItemElement

- (QSelectItemElement *)initWithIndex:(NSUInteger)index selectSection:(QSelectSection *)section
{
    if (self = [super init]) {
        _selectSection = section;
        _index = index;
        _title = [[_selectSection.items objectAtIndex:_index] description];
    }
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller
{
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    if ([_selectSection.selectedIndexes containsObject:[NSNumber numberWithUnsignedInteger:_index]]) {
        [self setUpCheckmarkForCell:cell];
    } else {
        [self removeCheckmarkForCell:cell];
    }

    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath
{
    [super selected:tableView controller:controller indexPath:indexPath];
    
    NSNumber *numberIndex = [NSNumber numberWithUnsignedInteger:_index];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_selectSection.multipleAllowed)
    {
        if ([_selectSection.selectedIndexes containsObject:numberIndex]) {
            [self removeCheckmarkForCell:selectedCell];
            [_selectSection.selectedIndexes removeObject:numberIndex];
        } else {
            [self setUpCheckmarkForCell:selectedCell];
            [_selectSection.selectedIndexes addObject:numberIndex];
        }
    }
    else
    {
        if (![_selectSection.selectedIndexes containsObject:numberIndex])
        {
            NSNumber *oldCellRowNumber = [_selectSection.selectedIndexes count] > 0 ? [_selectSection.selectedIndexes objectAtIndex:0] : nil;
            if (oldCellRowNumber)
            {
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                            [NSIndexPath indexPathForRow:[oldCellRowNumber unsignedIntegerValue]
                                                               inSection:indexPath.section]];
                
                [self removeCheckmarkForCell:oldCell];
                [_selectSection.selectedIndexes removeObject:oldCellRowNumber];
                [oldCell setNeedsDisplay];
            }
            
            [self setUpCheckmarkForCell:selectedCell];
            [_selectSection.selectedIndexes addObject:numberIndex];
        }
    }

    if (_selectSection.onSelected) {
        _selectSection.onSelected();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setUpCheckmarkForCell:(UITableViewCell *)cell
{
    if (_selectSection.checkmarkView != nil) {
        cell.accessoryView = _selectSection.checkmarkView;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    }
}

- (void)removeCheckmarkForCell:(UITableViewCell *)cell
{
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
}

@end
