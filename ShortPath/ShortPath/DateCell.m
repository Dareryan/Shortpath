//
//  DateCell.m
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-09.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "DateCell.h"

@implementation DateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _datePicker = [[UIDatePicker alloc] initWithFrame:self.contentView.bounds];
        [self addSubview:_datePicker];
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
