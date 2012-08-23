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
 key => $conf->get_key
, token => $conf->get_token
, idMember_or_username => "me"
);

print Dumper $cards;

say ">>>End of script ?";
