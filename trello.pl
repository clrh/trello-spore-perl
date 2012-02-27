#!/bin/perl

use Modern::Perl;
use Net::HTTP::Spore;
use Config::YAML;

my $conf = Config::YAML->new( config => "conf/mytrello.yaml");

my $client = Net::HTTP::Spore->new_from_spec('spec/trello.json',trace => '1=logs/log_spore_trello.log');
$client->enable('Format::JSON');

# 1st example: https://trello.com/1/boards/<BOARDID>?key=<KEY>&token=<TOKEN>&cards=all
# gives something like {"id":"4e7279550a78dcdfe520b4f7","name":"sandbox","desc":"","closed":false,"idOrganization":"","pinned":false,"url":"https://trello.com/board/sandbox/4e7279550a78dcdfe520b4f7","prefs":{"invitations":"members","comments":"members","voting":"members","permissionLevel":"public"}}


my $cards = $client->boards(
  id => $conf->get_boardid,
, key => $conf->get_key
);

say ">>>End of script ?";
