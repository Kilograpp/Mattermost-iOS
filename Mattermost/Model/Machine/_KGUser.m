// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGUser.m instead.

#import "_KGUser.h"

@implementation KGUserID
@end

@implementation _KGUser

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (KGUserID*)objectID {
	return (KGUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"nicknameWidthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"nicknameWidth"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic backendStatus;

@dynamic email;

@dynamic firstName;

@dynamic identifier;

@dynamic lastName;

@dynamic nickname;

@dynamic nicknameWidth;

- (float)nicknameWidthValue {
	NSNumber *result = [self nicknameWidth];
	return [result floatValue];
}

- (void)setNicknameWidthValue:(float)value_ {
	[self setNicknameWidth:@(value_)];
}

- (float)primitiveNicknameWidthValue {
	NSNumber *result = [self primitiveNicknameWidth];
	return [result floatValue];
}

- (void)setPrimitiveNicknameWidthValue:(float)value_ {
	[self setPrimitiveNicknameWidth:@(value_)];
}

@dynamic status;

- (int16_t)statusValue {
	NSNumber *result = [self status];
	return [result shortValue];
}

- (void)setStatusValue:(int16_t)value_ {
	[self setStatus:@(value_)];
}

- (int16_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result shortValue];
}

- (void)setPrimitiveStatusValue:(int16_t)value_ {
	[self setPrimitiveStatus:@(value_)];
}

@dynamic username;

@dynamic channels;

@dynamic posts;

- (NSMutableSet<KGPost*>*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet<KGPost*> *result = (NSMutableSet<KGPost*>*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@end

@implementation KGUserAttributes 
+ (NSString *)backendStatus {
	return @"backendStatus";
}
+ (NSString *)email {
	return @"email";
}
+ (NSString *)firstName {
	return @"firstName";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)lastName {
	return @"lastName";
}
+ (NSString *)nickname {
	return @"nickname";
}
+ (NSString *)nicknameWidth {
	return @"nicknameWidth";
}
+ (NSString *)status {
	return @"status";
}
+ (NSString *)username {
	return @"username";
}
@end

@implementation KGUserRelationships 
+ (NSString *)channels {
	return @"channels";
}
+ (NSString *)posts {
	return @"posts";
}
@end

