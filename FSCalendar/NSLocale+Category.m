//
//  NSLocale+Category.m
//  FSCalendar
//
//  Created by Hussein Habibi Juybari on 10/10/18.
//  Copyright © 2018 wenchaoios. All rights reserved.
//

#import "NSLocale+Category.h"

@implementation NSLocale(Category)

-(BOOL) isRtlLocale {
    NSString *lanId = self.localeIdentifier;
    NSArray<NSString *> *langSep = [lanId componentsSeparatedByString:@"-"];
  
    NSLocaleLanguageDirection langDirction = [NSLocale characterDirectionForLanguage:langSep.firstObject];

    return langDirction;
}

@end
