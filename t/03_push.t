use List::ToString;
use Mojo::Util qw/dumper/;

$\ = "\n"; $, = "\t"; binmode(STDOUT, ":utf8");

my $l = [ "a".."f" ];

my $r = $l->to_string;

print dumper $r;
print dumper $r->to_array;

push $l->@*, "z";

my $r = $l->to_string;

print dumper $l->to_string->to_array;

print dumper 'f##'->to_array;


print dumper pack 'N', 12347;

my $lo = List::ToString::Object->new('a'..'m');

print dumper $lo;

print dumper $lo->to_string->to_array;

print dumper [ $lo->@* ];

push $lo->@*, 'z';

print dumper [ $lo->@* ];

print dumper $lo;

print dumper $lo->to_array;

print dumper "$lo";

my $so = List::ToString::Object->new(\($lo->to_string));

print dumper $so;

my $mo = List::ToString::Object->new([[qw/a b c/]]);
