// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.m instead.

#import "_KGTeam.h"

@implementation KGTeamID
@end

@implementation _KGTeam

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Team";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Team" inManagedObjectContext:moc_];
}

- (KGTeamID*)objectID {
	return (KGTeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic identifier;

@dynamic name;

@dynamic channels;

- (NSMutableSet<KGChannel*>*)channelsSet {
	[self willAccessValueForKey:@"channels"];

	NSMutableSet<KGChannel*> *result = (NSMutableSet<KGChannel*>*)[self mutableSetValueForKey:@"channels"];

	[self didAccessValueForKey:@"channels"];
	return result;
}

@end

@implementation KGTeamAttributes 
+ (NSString *)displayName {
	return @"displayName";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)name {
	return @"name";
}
@end

@implementation KGTeamRelationships 
+ (NSString *)channels {
	return @"channels";
}
@end

