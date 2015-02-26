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

=begin comment
Keeping track of where we were, return the next possible value for a token
=cut
my $dog = 0;
sub getNextReplacementForToken {
	# print $dog++;
}

my $token;
foreach(@tokenized_string) {
	if($token = isToken($_)) {
		# print "$_ matches token $token\n";

		getNextReplacementForToken($token);

	} else {
		# print "NO\n";
	}
}

foreach(@replaceable_tokens) {
#	print $_ . "\n";
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
