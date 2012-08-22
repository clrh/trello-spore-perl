#!/bin/perl

use Modern::Perl;
use Net::HTTP::Spore;
use Config::YAML;
use Data::Dumper;

my $conf = Config::YAML->new( config => "conf/mytrello.yaml");
warn Dumper $conf->get_key;

my $client = Net::HTTP::Spore->new_from_spec('spec/trello.json',trace => '1=logs/log_spore_trello.log');
$client->enable('Format::JSON');

# 1st example: https://trello.com/1/boards/<BOARDID>?key=<KEY>&token=<TOKEN>&cards=all
my $cards = $client->get_members_idmember_or_username_boards(
 key => "b79ef04376f5d5e51a8770180fb275e6"
, token => "4f472f09719da1c5960f2df6208fd168752acea375173b1dfec2e28c891a4b3c"
, idMember_or_username => "me"
);

print Dumper $cards;

say ">>>End of script ?";
