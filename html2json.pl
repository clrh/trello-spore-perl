#!/usr/bin/perl

use Modern::Perl;
use JSON;
use Plient;
use Getopt::Long;

my $conf = {
    name => "Trello",
    base_url => "https://api.trello.com",
    formats => [ "json" ],
    version => "0.1",
    methods => {}
};

my $output = 'trello.json';
my $verbose = 0;

GetOptions(
    'output|o:s' => \$output,
    'verbose|v' => \$verbose,
);

my @names = qw(action board card checklist list member notification organization
    search token type);

my $global_html = "";
foreach my $name (@names) {
    my $url = "http://www.trello.com/docs/api/$name/index.html";
    $verbose and print "Retrieving $url...\n";
    my $html = plient('get', $url);
    $html =~ s|\n||g;
    $html =~ s|<div class=".*?" id="$name">||g;
    $global_html .= $html;
}

while ($global_html =~ m|(<div class="section".*?</div>)|g) {
    my $section = $1;
    my ($id) = ($section =~ m|<div class="section" id="(.*?)"|);
    my ($method, $path) = ($section =~ m|<h2>([A-Z]+) <span .*?>(.*?)</span>.*?</h2>|);
    my @required_params = ('key');
    while ($path =~ m|\[(.*?)\]|g) {
        my ($new_arg, $arg) = ($1,$1);
        $new_arg =~ s| |_|g;
        $path =~ s|\[$arg\]|:$new_arg|g;
        push @required_params, $new_arg;
    }
    $path =~ s|\[(.*?)\]|:$1|g;
    my @optional_params;
    push @optional_params, 'token' if (0 == grep /^token$/, @required_params);
    while ($section =~ m|<span class="pre">([0-9A-Za-z_]*?)</span></tt> \(optional\)|g) {
        my $arg = $1;
        push @optional_params, $arg;
    }
    my $method_name = $id;
    $method_name =~ s|1-||;
    $method_name =~ s|-|_|g;
    $conf->{methods}->{$method_name} = {
        path => $path,
        method => $method,
        required_params => \@required_params,
        optional_params => \@optional_params,
    };
}

if ($output eq '-') {
    print to_json($conf, { pretty => 1 });
    print "\n";
} else {
    open my $fh, '>', $output or die "Can't open $output: $!";
    print $fh to_json($conf, { pretty => 1 });
    $verbose and print "Output written to $output.\n";
}
