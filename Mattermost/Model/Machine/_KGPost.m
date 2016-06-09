// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGPost.m instead.

#import "_KGPost.h"

const struct KGPostAttributes KGPostAttributes = {
	.channelId = @"channelId",
	.createdAt = @"createdAt",
	.deletedAt = @"deletedAt",
	.identifier = @"identifier",
	.message = @"message",
	.type = @"type",
	.updatedAt = @"updatedAt",
	.userId = @"userId",
};

const struct KGPostRelationships KGPostRelationships = {
	.author = @"author",
	.channel = @"channel",
};

@implementation KGPostID
@end

@implementation _KGPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Post";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc_];
}

- (KGPostID*)objectID {
	return (KGPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic channelId;

@dynamic createdAt;

@dynamic deletedAt;

@dynamic identifier;

@dynamic message;

@dynamic type;

@dynamic updatedAt;

@dynamic userId;

@dynamic author;

@dynamic channel;

@end

