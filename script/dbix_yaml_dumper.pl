#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use DBIx::YAML::Dumper;

DBIx::YAML::Dumper->new_with_option(@ARGV)->run;

__END__

=head1 NAME

dbix_yaml_dumper.pl - DBIx::YAML::Dumper CLI tool

=head1 SYNOPSIS

    % dbix_yaml_dumper.pl [options]
        --dsn|d=s          # database dsn like --dsn="dbi:mysql:database=$database;host=$hostname;port=$port"; (Requred)
        --user|u=s         # database user
        --password|p=s     # database password
        --output_dir|o=s   # output yaml files dir like --output_dir=./master-data
        --tables|t=s       # indicate some tables like --tables=user --tables=post --tables=age
        --test_fixture_dbi # output one fixture.yaml file and  Test::Fixture::DBI data (Defualt: false)

=head1 DESCRIPTION

DBIx::YAML::Dumper CLI tool

=head1 SEE ALSO

L<DBIx::YAML::Dumper>,L<make_fixture_yaml.pl>

=head1 LICENSE

Copyright (C) Hiroyuki Akabane.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hiroyuki Akabane E<lt>hirobanex@gmail.comE<gt>
