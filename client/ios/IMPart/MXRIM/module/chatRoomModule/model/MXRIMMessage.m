//
//  MXRIMMessage.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/15.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMMessage.h"
#import "NSObject+MXRModel.h"
//#define MXRIMMessageDBName @"IMMessage.sqlite"

@implementation MXRIMMessage

//+ (LKDBHelper *)getUsingLKDBHelper
//{
//    static LKDBHelper* db;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:MXRIMMessageDBName];
//        db = [[LKDBHelper alloc] initWithDBPath:dbPath];
//    });
//    return db;
//}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _senderId = @"";
    _senderDisplayName = @"";
    _createTime = _updateTime = [NSDate new];
    _content = @"";
    return self;
}

- (NSString *)text
{
    if ([_content isKindOfClass:[NSString class]] && [_content length] > 0) {
        return self.content;
    }
    return _text ?: @"";
}

- (NSDate *)date
{
    return  _createTime ? _createTime : (_date ? _date : [NSDate date]);
}

- (NSString *)senderId
{
    return _senderId ?: @"0";
}

- (NSString *)senderDisplayName
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

#pragma mark - Initialization

+ (instancetype)messageWithSenderId:(NSString *)senderId
                        displayName:(NSString *)displayName
                               text:(NSString *)text
{
    return [[self alloc] initWithSenderId:senderId
                        senderDisplayName:displayName
                                     date:[NSDate date]
                                     text:text];
}

- (instancetype)initWithSenderId:(NSString *)senderId
               senderDisplayName:(NSString *)senderDisplayName
                            date:(NSDate *)date
                            text:(NSString *)text
{
    NSParameterAssert(text != nil);
    
    self = [self initWithSenderId:senderId senderDisplayName:senderDisplayName date:date isMedia:NO];
    if (self) {
        _text = [text copy];
    }
    return self;
}

+ (instancetype)messageWithSenderId:(NSString *)senderId
                        displayName:(NSString *)displayName
                              media:(id<JSQMessageMediaData>)media
{
    return [[self alloc] initWithSenderId:senderId
                        senderDisplayName:displayName
                                     date:[NSDate date]
                                    media:media];
}

- (instancetype)initWithSenderId:(NSString *)senderId
               senderDisplayName:(NSString *)senderDisplayName
                            date:(NSDate *)date
                           media:(id<JSQMessageMediaData>)media
{
    NSParameterAssert(media != nil);
    
    self = [self initWithSenderId:senderId senderDisplayName:senderDisplayName date:date isMedia:YES];
    if (self) {
        _media = media;
    }
    return self;
}

- (instancetype)initWithSenderId:(NSString *)senderId
               senderDisplayName:(NSString *)senderDisplayName
                            date:(NSDate *)date
                         isMedia:(BOOL)isMedia
{
    NSParameterAssert(senderId != nil);
    NSParameterAssert(senderDisplayName != nil);
    NSParameterAssert(date != nil);
    
    self = [super init];
    if (self) {
        _senderId = [senderId copy];
        _senderDisplayName = [senderDisplayName copy];
        _date = [date copy];
        _isMediaMessage = isMedia;
    }
    return self;
}

- (NSUInteger)messageHash
{
    NSUInteger contentHash = self.isMediaMessage ? [self.media mediaHash] : self.text.hash;
    NSInteger messageUUIDHash = self.messageUUID.hash;
    return self.senderId.hash ^ self.date.hash ^ contentHash ^ messageUUIDHash;
//    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    MXRIMMessage *aMessage = (MXRIMMessage *)object;
    return [self.messageUUID isEqual:aMessage.messageUUID];
//    if (self.isMediaMessage != aMessage.isMediaMessage) {
//        return NO;
//    }
//
//    BOOL hasEqualContent = self.isMediaMessage ? [self.media isEqual:aMessage.media] : [self.text isEqualToString:aMessage.text];
//
//    return [self.senderId isEqualToString:aMessage.senderId]
//    && [self.senderDisplayName isEqualToString:aMessage.senderDisplayName]
//    && ([self.date compare:aMessage.date] == NSOrderedSame)
//    && hasEqualContent;
}

- (NSUInteger)hash
{
    return self.messageUUID.hash;
//    NSUInteger contentHash = self.isMediaMessage ? [self.media mediaHash] : self.text.hash;
//    NSInteger messageUUID = self.messageUUID.hash;
//    return self.senderId.hash ^ self.date.hash ^ contentHash ^ messageUUID;
}

- (NSString *)description
{
    return [self mxr_modelDescription];
//    return [NSString stringWithFormat:@"<%@: senderId=%@, senderDisplayName=%@, date=%@, isMediaMessage=%@, text=%@, media=%@>",
//            [self class], self.senderId, self.senderDisplayName, self.date, @(self.isMediaMessage), self.text, self.media];
}

- (id)debugQuickLookObject
{
    return [self.media mediaView] ?: [self.media mediaPlaceholderView];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mxr_modelInitWithCoder:aDecoder];
//    self = [super init];
//    if (self) {
//        _senderId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(senderId))];
//        _senderDisplayName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(senderDisplayName))];
//        _date = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(date))];
//        _isMediaMessage = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isMediaMessage))];
//        _text = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(text))];
//        _media = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(media))];
//    }
//    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mxr_modelEncodeWithCoder:aCoder];
//    [aCoder encodeObject:self.senderId forKey:NSStringFromSelector(@selector(senderId))];
//    [aCoder encodeObject:self.senderDisplayName forKey:NSStringFromSelector(@selector(senderDisplayName))];
//    [aCoder encodeObject:self.date forKey:NSStringFromSelector(@selector(date))];
//    [aCoder encodeBool:self.isMediaMessage forKey:NSStringFromSelector(@selector(isMediaMessage))];
//    [aCoder encodeObject:self.text forKey:NSStringFromSelector(@selector(text))];
//
//    if ([self.media conformsToProtocol:@protocol(NSCoding)]) {
//        [aCoder encodeObject:self.media forKey:NSStringFromSelector(@selector(media))];
//    }
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [self mxr_modelCopy];
//    if (self.isMediaMessage) {
//        return [[[self class] allocWithZone:zone] initWithSenderId:self.senderId
//                                                 senderDisplayName:self.senderDisplayName
//                                                              date:self.date
//                                                             media:self.media];
//    }
//
//    return [[[self class] allocWithZone:zone] initWithSenderId:self.senderId
//                                             senderDisplayName:self.senderDisplayName
//                                                          date:self.date
//                                                          text:self.text];
}


#pragma mark - DB op
+ (NSString *)getPrimaryKey
{
    return @"messageUUID";
}

+ (BOOL)isContainParent
{
    return YES;
}

+ (NSDateFormatter *)getModelDateFormatter
{
    static NSDateFormatter* dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
    }
    return dateFormatter;
}

@end

@implementation MXRIMMessage (MXRDB)

+ (NSArray *)sortedChatMessageArrayWithCreateTime:(NSDate *)date withCount:(NSInteger)count
{
    NSString *dateStr = [[self getModelDateFormatter] stringFromDate:date];
    
//    NSArray *messageArray = [[self getUsingLKDBHelper] search:[self class] where:nil orderBy:@"createTime" offset:0 count:count];
//
    NSArray *messageArray = [[self getUsingLKDBHelper] search:[self class] where:[NSString stringWithFormat:@"createTime < '%@' and status = 0", dateStr] orderBy:@"createTime DESC" offset:0 count:count];
    NSEnumerator *enumerator = [messageArray reverseObjectEnumerator];
    return [enumerator allObjects];
}

@end
