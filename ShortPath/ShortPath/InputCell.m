//
//  InputCell.m
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-08.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "InputCell.h"

@implementation InputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        [self addSubview:_textField];
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
