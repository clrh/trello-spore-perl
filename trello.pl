#!/bin/perl

use Modern::Perl;
use Net::HTTP::Spore;
use Config::YAML;

my $conf = Config::YAML->new( config => "conf/mytrello.yaml");

my $client = Net::HTTP::Spore->new_from_spec('spec/trello.json',trace => '1=logs/log_spore_trello.log');
$client->enable('Net::HTTP::Spore::Middleware::Format::JSON');

# 1st example: https://trello.com/1/boards/<BOARDID>?key=<KEY>&token=<TOKEN>&cards=all
my $cards = $client->boards(
  id => $conf->get_boardid
, key => $conf->get_key
, token => $conf->get_token
, cards => 'all'
);

say ">>>End of script ?";
