#!/usr/bin/perl

=head1 

[Counting with md5sum](http://www.reddit.com/live/thjep4nr9895) on Reddit has gotten near impossible to do without brute force of some kind.

md5nder.pl attempts to find md5 hashes which end with a specific number.

This program accepts two unnamed command line parameters:

    1. is the template we wish to use, e.g.  'Okay, but time machines are so ADJECTIVE!'
    2. is the number we are trying to match, e.g. 124

=cut

use strict;
use warnings;
use diagnostics;			# explains why stuff is busted

=begin comment
$files is a hash which links the replaceable tokens in strings with files containing possible replacement values
@replaceable_tokens is an array of the tokens which will be replaced in the input string
=cut
my %files = (
	'ADJECTIVE' => 'adjectives.txt',
	'NOUN'	=> 'nouns.txt',
	'VERB'  => 'verbs.txt'
);

my @replaceable_tokens = keys %files;
my $replaceable_tokens_ORed = join('|',@replaceable_tokens);		# 'ADJECTIVE|NOUN|VERB' for use in split regex


my ($string, $target) = @ARGV;		# grab two unnamed command line parameters

my @tokenized_string = split(/($replaceable_tokens_ORed)/, $string);  # tokenize the input string while keeping tokens

=begin comment
Return the token matched by part of the input string if it matches
=cut
sub isToken {
	my $possible_token = $_[0];
	print "$possible_token\n";
	foreach(@replaceable_tokens) {
		if(index($possible_token, $_) == 0) {
			return $_;
		}
	}
    return 0;
}


sub findAllVariants {

}

###=begin comment
###Keeping track of where we were, return the next possible value for a token
###=cut
my $dog = 0;
sub getNextReplacementForToken {
	print $dog++;
}

=begin comment
Loop through the tokenized array and create a counter for each Token.
The counter will keep track of how far we've gone through that token's list of words.
=cut	
my ($token, $num_tokens);
my (%token_replacement_counter, %token_num_replacements, %token_types);			# will know how many words we've used for each token

$num_tokens = 0;		## this should be in constructor if all this crap is made into an object

sub setUpTokenTrackers {
		$token_replacement_counter{$num_tokens} = 0;	# for each token, we've used 0 words so far
		$token_num_replacements{$num_tokens} = length $token;		# should be number of words in file per token type
		$token_types{$num_tokens} = $_[0];				# ADJECTIVE, etc

		$num_tokens++;
}

foreach(@tokenized_string) {
	if($token = isToken($_)) {
		setUpTokenTrackers($token);
#		getNextReplacementForToken($token);
	}
}

my $panic_counter;
my $keep_going = 1;
while($keep_going) {
	$panic_counter ++;
	if($panic_counter > 1000) {
		print "sorry I panicked!!!\n";
		exit;
	}
	# We keep going unless each token has been replaced with its full compliment of replacements
	foreach(keys %token_num_replacements) {
		$keep_going = 0;
		if($token_replacement_counter{$_} < $token_num_replacements{$_}) {
			$keep_going = 1;
		}
	}

	###  this is just a shitty loop for testing
	## it increments allll the tokens at the same time
	# we still need to increment each separately per loop.
	$num_tokens = 0;
	foreach(@tokenized_string) {
		if($token = isToken($_)) {
			$token_replacement_counter{$num_tokens} = $token_replacement_counter{$num_tokens} + 1;	# for each token, we've used 0 words so far
			$num_tokens++;
		}
	}
}

print "only counted to " . $panic_counter . "!! yeeeha!! \n";



###
foreach(keys %token_replacement_counter) {
	print $_ . " = " . $token_replacement_counter{$_} . "\n";
}
foreach(keys %token_num_replacements) {
	print $_ . " = " . $token_num_replacements{$_} . "\n";
}
foreach(keys %token_types) {
	print $_ . " = " . $token_types{$_} . "\n";
}


# target="$1"

# echo searching for $target

# # read each line of a file or output stream
# while read line
# do
#     hash="$(echo -n "$line" | md5)"
#     if echo $hash | grep $target$;
#     then
#        echo $line
#     fi
# done
