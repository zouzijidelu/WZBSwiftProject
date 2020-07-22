//
//  IMEURLRequestSerialization.m
//  imetis
//
//  Created by valenti on 2019/3/4.
//  Copyright © 2019 iTalkBB Team. All rights reserved.
//

#import "IMEURLRequestSerialization.h"

@interface IMEURLRequestSerialization()

@property (readwrite, nonatomic, strong) id value;
@property (readwrite, nonatomic, strong) id field;

@end

@implementation IMEURLRequestSerialization

- (instancetype)initWithField:(id)field value:(id)value {
    self = [super init];
    if (self) {
        self.field = field;
        self.value = value;
    }
    return self;
}

#pragma mark -

FOUNDATION_EXPORT NSArray * IMQueryStringPairsFromDictionary(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * IMQueryStringPairsFromKeyAndValue(NSString *key, id value);

+ (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    
    NSMutableArray* mutableParis = [NSMutableArray array];
    for (IMEURLRequestSerialization* pair in IMQueryStringPairsFromDictionary(parameters)) {
        [mutableParis addObject:[pair URLEncodedStringValue]];
    }
    return [mutableParis componentsJoinedByString:@"&"];
}

NSArray * IMQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return IMQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * IMQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES             selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:IMQueryStringPairsFromKeyAndValue((key ?                                              [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:IMQueryStringPairsFromKeyAndValue([NSString                       stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:IMQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[IMEURLRequestSerialization alloc] initWithField:key                                value:value]];
    }
    return mutableQueryStringComponents;
}

static NSString * IMPercentEscapedStringFromString(NSString *string) {
    static NSString * const kLYCharactersGeneralDelimitersToEncode = @":#[]@";                                                                                              // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kLYCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kLYCharactersGeneralDelimitersToEncode stringByAppendingString:kLYCharactersSubDelimitersToEncode]];
    static NSUInteger const batchSize = 50;
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        index += range.length;
    }
    return escaped;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return IMPercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", IMPercentEscapedStringFromString([self.field description]), IMPercentEscapedStringFromString([self.value description])];
    }
}


@end
