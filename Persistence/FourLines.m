//
//  FourLines.m
//  Persistence
//
//  Created by Vasilii on 12.06.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "FourLines.h"

static NSString *kLinesKey = @"kLinesKey";

@implementation FourLines

#pragma mark - Coding
//Мы шифруем все четыре свойства в методе encodeWithCoder: и расшифровываем их все с использованием тех же самых четырех ключевых значений в методе initWithCoder:

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.lines = [aDecoder decodeObjectForKey:kLinesKey];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.lines forKey:kLinesKey];
}

#pragma mark - Copying

//В методе copyWithZone: создаем новый объект типа FourLines и копируем в него все четыре строки.
- (id)copyWithZone:(NSZone *)zone {
    FourLines *copy = [[[self class] allocWithZone:zone] init];
    NSMutableArray *linesCopy = [NSMutableArray array];
    for (id line in self.lines) {
        [linesCopy addObject:[line copyWithZone:zone]];
    }
    copy.lines = linesCopy;
    return copy;
}

@end
