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
use File::Slurp;
use Digest::MD5 qw(md5_hex);

my $MAX_PANIC = 100000000;

=begin comment
$files is a hash which links the replaceable tokens in strings with files containing possible replacement values
@replaceable_tokens is an array of the tokens which will be replaced in the input string
=cut
my %files = (
	'ADJECTIVE' => 'adjectives.txt',
	'PLURALS'	=> 'plurals.txt',
	'NOUN'	=> 'nouns.txt',
	'VERB'  => 'verbs.txt',
	'COUNT' => 'count.txt'
);

my @replaceable_tokens = keys %files;
my $replaceable_tokens_ORed = join('|',@replaceable_tokens);		# 'ADJECTIVE|NOUN|VERB' for use in split regex

=begin comment
	Command line parameters are unnamed, so must be sent in order:

	1. quoted string to be used as the template.  This can include "ADJECTIVE" or "PLURALS" etc (see source code) which will be replaced by samples
	2. target string (number) for the end of the hash to match
	3. string representing binary flags for which words of the template can have their case modified, 
	    e.g. 01100 says we can change case of the second and third words

=cut
my ($string, $target, $cap_flags) = @ARGV;		# grab unnamed command line parameters

sub preProcessString {
	my $string = $_[0];
	$string =~ s|\\!|!|g;				# bangs have to be escaped in bash, but the \! is passed to Perl, so I need to lop the \
	return $string;
}

$string = preProcessString($string);

my @tokenized_string = split(/($replaceable_tokens_ORed)/, $string);  # tokenize the input string while keeping tokens

=begin comment
Return the token matched by part of the input string if it matches
=cut
sub isToken {
	my $possible_token = $_[0];
#	print "$possible_token\n";
	foreach(@replaceable_tokens) {
		if(index($possible_token, $_) == 0) {
			return $_;
		}
	}
    return 0;
}

=begin comment
Loop through the tokenized array and create a counter for each Token.
The counter will keep track of how far we've gone through that token's list of words.
=cut	
my ($token, $num_tokens, $which_token);
my %token_replacement_counter;		# will know how many words we've used for each token
my %token_num_replacements;			# will know how many replacments there are  (superfluous?)
my %token_types;					# know what types of tokens exist
my %token_replacements;				# the actual list of replacements

$num_tokens = 0;		## this should be in constructor if all this crap is made into an object

sub setUpTokenTrackers {
	my $token = $_[0];		# ADJECTIVE, etc
	$token_types{$num_tokens} = $token;
	@{$token_replacements{$token}} = read_file($files{$token}, chomp => 1);
	$token_replacement_counter{$num_tokens} = 0;	# for each token, we've used 0 words so far
	$token_num_replacements{$num_tokens} = scalar @{$token_replacements{$token}};		# should be number of words in file per token type

	$num_tokens++;
}

foreach(@tokenized_string) {
	if($token = isToken($_)) {
		setUpTokenTrackers($token);
	}
}

my $panic_counter;
my $keep_going = 1;
my $try_this_string;
my $md5_digest;

while($keep_going) {
	$panic_counter ++;
	if($panic_counter >= $MAX_PANIC) {
		print "Sorry I panicked after $panic_counter iterations!!!\n";
		exit;
	}

	# loop through the bits of string and fill in the next word in each token or the bit of string
	$which_token = 0;
	$try_this_string = "";
	foreach(@tokenized_string) {
		if($token = isToken($_)) {
			# append the current replacement of the token type for the current token number
			$try_this_string .= $token_replacements{$token_types{$which_token}}[$token_replacement_counter{$which_token}];
			$which_token++;
		} else {
			$try_this_string .= $_;		# append the non-token segment 
		}
	}

	$md5_digest = md5_hex($try_this_string);
	if($md5_digest =~ /$target$/) {
		print $md5_digest . "    ->   " . $try_this_string . "\n";
	}


	# loop through the token counters and increment the appropriate ones
	foreach(sort keys %token_replacement_counter) {
		if($_ == 0) {
			# We always increment the ones position
			$token_replacement_counter{$_} = $token_replacement_counter{$_} + 1;
		} elsif($token_replacement_counter{$_-1} == $token_num_replacements{$_-1}) {
			# The previous position has reached its max, so set it to 0 and increment the current
			$token_replacement_counter{$_-1} = 0;
			$token_replacement_counter{$_} = $token_replacement_counter{$_} + 1;
		}
	}

	# We keep going unless each token has been replaced with its full compliment of replacements
	foreach(sort keys %token_num_replacements) {
		$keep_going = 0;
		if($token_replacement_counter{$_} < $token_num_replacements{$_}) {
			$keep_going = 1;
		}
	}
}

