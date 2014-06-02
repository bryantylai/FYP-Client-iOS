//
//  FYPSearchBarTableViewCell.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/29/14.
//
//

#import "FYPSearchBarTableViewCell.h"

@implementation FYPSearchBarTableViewCell
{
    UITableView *parentTableView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        id view = [self superview];
        
        while (view && [view isKindOfClass:[UITableView class]] == NO)
            view = [view superview];
        
        parentTableView = (UITableView *)view;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
