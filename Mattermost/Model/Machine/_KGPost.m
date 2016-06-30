// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGPost.m instead.

#import "_KGPost.h"

@implementation KGPostID
@end

@implementation _KGPost

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

@dynamic backendPendingId;

@dynamic channelId;

@dynamic createdAt;

@dynamic creationDay;

@dynamic deletedAt;

@dynamic identifier;

@dynamic message;

@dynamic type;

@dynamic updatedAt;

@dynamic userId;

@dynamic author;

@dynamic channel;

@dynamic files;

- (NSMutableSet<KGFile*>*)filesSet {
	[self willAccessValueForKey:@"files"];

	NSMutableSet<KGFile*> *result = (NSMutableSet<KGFile*>*)[self mutableSetValueForKey:@"files"];

	[self didAccessValueForKey:@"files"];
	return result;
}

@end

@implementation KGPostAttributes 
+ (NSString *)backendPendingId {
	return @"backendPendingId";
}
+ (NSString *)channelId {
	return @"channelId";
}
+ (NSString *)createdAt {
	return @"createdAt";
}
+ (NSString *)creationDay {
	return @"creationDay";
}
+ (NSString *)deletedAt {
	return @"deletedAt";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)message {
	return @"message";
}
+ (NSString *)type {
	return @"type";
}
+ (NSString *)updatedAt {
	return @"updatedAt";
}
+ (NSString *)userId {
	return @"userId";
}
@end

@implementation KGPostRelationships 
+ (NSString *)author {
	return @"author";
}
+ (NSString *)channel {
	return @"channel";
}
+ (NSString *)files {
	return @"files";
}
@end

