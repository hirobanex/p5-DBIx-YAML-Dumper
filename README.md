[![Build Status](https://travis-ci.org/hirobanex/p5-DBIx-YAML-Dumper.png?branch=master)](https://travis-ci.org/hirobanex/p5-DBIx-YAML-Dumper) [![Coverage Status](https://coveralls.io/repos/hirobanex/p5-DBIx-YAML-Dumper/badge.png?branch=master)](https://coveralls.io/r/hirobanex/p5-DBIx-YAML-Dumper?branch=master)
# NAME

DBIx::YAML::Dumper - output database data to yaml file

# SYNOPSIS

    #cli interface
    dbix_yaml_dumper.pl --user=root --password=password --dsn="dbi:mysql:your_dabasename"
    dbix_yaml_dumper.pl --user=root --password=password --dsn="dbi:mysql:your_dabasename" --tables="item" --tables="monster"
        

    #output yaml file by table
    user.yaml
    post.yaml

    # OO-interface
    use DBIx::YAML::Dumper;

    my $dumper = DBIx::YAML::Dumper->new(
        dsn              => "dbi:mysql:your_dabasename",
        user             => "root",
        password         => "password",
        output_dir       => "./master-data/",
        tables           => +[qw/monster item job/],
        test_fixture_dbi => 0, # See Test::Fixture::DBI
    );

    $dumper->run();

# DESCRIPTION

DBIx::YAML::Dumper is write your database table's data to yaml file.

# new OPTIONS

- __dsn__

    database dsn.

- __user__

    database user.

- __password__

    database password.

- __tables :ArrayRef__

    output tables.

- __test\_fixture\_dbi__
default = 0. If test\_fixture\_dbi = 1, output data together in one 'fixture.yaml', and yaml structure is Test::Fixture::DBI.

# SEE ALSO

[dbix\_yaml\_dumper.pl](http://search.cpan.org/perldoc?dbix\_yaml\_dumper.pl), [Test::Fixture::DBI](http://search.cpan.org/perldoc?Test::Fixture::DBI), [DBIx::FixtureLoader](http://search.cpan.org/perldoc?DBIx::FixtureLoader)

# LICENSE

Copyright (C) Hiroyuki Akabane.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Hiroyuki Akabane <hirobanex@gmail.com>
