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

	if ([key isEqualToString:@"currentTeamValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentTeam"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic currentTeam;

- (BOOL)currentTeamValue {
	NSNumber *result = [self currentTeam];
	return [result boolValue];
}

- (void)setCurrentTeamValue:(BOOL)value_ {
	[self setCurrentTeam:@(value_)];
}

- (BOOL)primitiveCurrentTeamValue {
	NSNumber *result = [self primitiveCurrentTeam];
	return [result boolValue];
}

- (void)setPrimitiveCurrentTeamValue:(BOOL)value_ {
	[self setPrimitiveCurrentTeam:@(value_)];
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
+ (NSString *)currentTeam {
	return @"currentTeam";
}
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

