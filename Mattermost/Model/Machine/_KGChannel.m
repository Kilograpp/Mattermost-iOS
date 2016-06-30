// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGChannel.m instead.

#import "_KGChannel.h"

@implementation KGChannelID
@end

@implementation _KGChannel

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Channel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Channel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Channel" inManagedObjectContext:moc_];
}

- (KGChannelID*)objectID {
	return (KGChannelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"firstLoadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"firstLoaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"messagesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"messagesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic backendType;

@dynamic createdAt;

@dynamic displayName;

@dynamic firstLoaded;

- (BOOL)firstLoadedValue {
	NSNumber *result = [self firstLoaded];
	return [result boolValue];
}

- (void)setFirstLoadedValue:(BOOL)value_ {
	[self setFirstLoaded:@(value_)];
}

- (BOOL)primitiveFirstLoadedValue {
	NSNumber *result = [self primitiveFirstLoaded];
	return [result boolValue];
}

- (void)setPrimitiveFirstLoadedValue:(BOOL)value_ {
	[self setPrimitiveFirstLoaded:@(value_)];
}

@dynamic header;

@dynamic identifier;

@dynamic lastPostDate;

@dynamic lastViewDate;

@dynamic messagesCount;

- (int64_t)messagesCountValue {
	NSNumber *result = [self messagesCount];
	return [result longLongValue];
}

- (void)setMessagesCountValue:(int64_t)value_ {
	[self setMessagesCount:@(value_)];
}

- (int64_t)primitiveMessagesCountValue {
	NSNumber *result = [self primitiveMessagesCount];
	return [result longLongValue];
}

- (void)setPrimitiveMessagesCountValue:(int64_t)value_ {
	[self setPrimitiveMessagesCount:@(value_)];
}

@dynamic name;

@dynamic purpose;

@dynamic shouldUpdateAt;

@dynamic teamId;

@dynamic updatedAt;

@dynamic members;

- (NSMutableSet<KGUser*>*)membersSet {
	[self willAccessValueForKey:@"members"];

	NSMutableSet<KGUser*> *result = (NSMutableSet<KGUser*>*)[self mutableSetValueForKey:@"members"];

	[self didAccessValueForKey:@"members"];
	return result;
}

@dynamic posts;

- (NSMutableSet<KGPost*>*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet<KGPost*> *result = (NSMutableSet<KGPost*>*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@dynamic team;

@end

@implementation KGChannelAttributes 
+ (NSString *)backendType {
	return @"backendType";
}
+ (NSString *)createdAt {
	return @"createdAt";
}
+ (NSString *)displayName {
	return @"displayName";
}
+ (NSString *)firstLoaded {
	return @"firstLoaded";
}
+ (NSString *)header {
	return @"header";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)lastPostDate {
	return @"lastPostDate";
}
+ (NSString *)lastViewDate {
	return @"lastViewDate";
}
+ (NSString *)messagesCount {
	return @"messagesCount";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)purpose {
	return @"purpose";
}
+ (NSString *)shouldUpdateAt {
	return @"shouldUpdateAt";
}
+ (NSString *)teamId {
	return @"teamId";
}
+ (NSString *)updatedAt {
	return @"updatedAt";
}
@end

@implementation KGChannelRelationships 
+ (NSString *)members {
	return @"members";
}
+ (NSString *)posts {
	return @"posts";
}
+ (NSString *)team {
	return @"team";
}
@end

