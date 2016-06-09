// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGChannel.m instead.

#import "_KGChannel.h"

const struct KGChannelAttributes KGChannelAttributes = {
	.backendType = @"backendType",
	.createdAt = @"createdAt",
	.displayName = @"displayName",
	.header = @"header",
	.identifier = @"identifier",
	.lastPostDate = @"lastPostDate",
	.messagesCount = @"messagesCount",
	.name = @"name",
	.purpose = @"purpose",
	.shouldUpdateAt = @"shouldUpdateAt",
	.teamId = @"teamId",
	.updatedAt = @"updatedAt",
};

const struct KGChannelRelationships KGChannelRelationships = {
	.posts = @"posts",
	.team = @"team",
};

@implementation KGChannelID
@end

@implementation _KGChannel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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

@dynamic header;

@dynamic identifier;

@dynamic lastPostDate;

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

@dynamic posts;

- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@dynamic team;

@end

