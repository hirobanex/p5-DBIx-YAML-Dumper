#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use DBIx::YAML::Dumper;

DBIx::YAML::Dumper->new_with_option(@ARGV)->run;
