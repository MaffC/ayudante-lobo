package Maff::Common::OSX;

use strict;
use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS/;

use Carp;
use Mac::Pasteboard;

$VERSION = 1.0.0;
@ISA = qw/Exporter/;
@EXPORT = qw//;
@EXPORT_OK = qw/&clipb_copy macintalk_say nc_notify/;
%EXPORT_TAGS = (all=>[@EXPORT_OK]);

sub copy ($);
sub nc_notify (@);
sub macintalk_say (@);
*clipb_copy = \&copy;

sub copy ($) {
	my $text = shift;
	my $clipboard = Mac::Pasteboard->new();
	$clipboard->clear();
	$clipboard->copy($text);
	$clipboard->copy($text, "public.utf8-plain-text");
	$clipboard->copy($text, "public.utf16-plain-text");
	$clipboard->copy($text, "public.utf16-external-plain-text");
}

sub nc_notify (@) {
	my ($title,$text) = @_;
	system("/usr/bin/osascript -e 'display notification \"$text\" with title \"$title\"' &");
}

sub macintalk_say (@) {
	my %args = @_;
	my $voice = $args{voice} || "Daniel";
	my $rate = $args{rate} || 190;
	my $text = $args{text} or croak "named parameter 'text' is required!";
	system("/usr/bin/say -v$voice -r$rate '$text' &");
}

1;
__END__
