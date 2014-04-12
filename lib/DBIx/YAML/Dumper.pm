package DBIx::YAML::Dumper;
use 5.008005;
use strict;
use warnings;
use DBI;
use DBIx::Inspector;
use YAML::Syck;
use Getopt::Long qw/:config posix_default no_ignore_case bundling auto_help pass_through/;
use Pod::Usage   qw/pod2usage/;

our $VERSION = "0.02";

sub new_with_option {
    my $class = shift;
    local @ARGV = @_;

    my %opt = ('fixture' => 0);
    GetOptions(\%opt, (
        'user|u=s',
        'password|p=s',
        'dsn|d=s',
        'output_dir|o=s',
        'tables|t=s@',
        'test_fixture_dbi|f!',
    )) or pod2usage(1);

    $opt{dsn} or die "dsn is mandatory option";

    my $self = $class->new(%opt);

    return $self;
}

sub new {
    my $class = shift;
    my %opt   = @_;

    my $dbh = DBI->connect($opt{dsn},$opt{user},$opt{password}) or die;

    my $tables = $opt{tables} || +[map {$_->name} DBIx::Inspector->new(dbh => $dbh)->tables];

    my $self = bless {
        dbh                 => $dbh,
        output_dir          => $opt{output_dir} || '.',
        tables              => $tables,
        test_fixture_dbi    => $opt{test_fixture_dbi},
    } ,$class;

    return $self;
}

sub run {
    my $self = shift;

    my @data;
    for my $table_name (@{$self->{tables}}) {
        my $sql = sprintf( 'SELECT * FROM %s', $table_name );

        my $rows = $self->{dbh}->selectall_arrayref( $sql, +{ Slice => +{} } );

        if ($self->{test_fixture_dbi}) {
            for my $row (@$rows) {
                push(@data, +{
                    schema => $table_name,
                    name => '',
                    data  => $row,
                });
            }
        }else{
            my $output_file_path = $self->{output_dir}."/$table_name.yaml";

            YAML::Syck::DumpFile( $output_file_path, $rows );
            print "write $table_name to $output_file_path\n";
        }
    }

    if ($self->{test_fixture_dbi}) {
        my $output_file_path = $self->{output_dir}."/fixture.yaml";

        YAML::Syck::DumpFile( $output_file_path, \@data );
        print "write all table to $output_file_path\n";
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

DBIx::YAML::Dumper - output database data to yaml file

=head1 SYNOPSIS

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

=head1 DESCRIPTION

DBIx::YAML::Dumper is write your database table's data to yaml file.

=head1 new OPTIONS

=over 4

=item B<dsn>

database dsn.

=item B<user>

database user.

=item B<password>

database password.

=item B<tables :ArrayRef>

output tables.

=item B<test_fixture_dbi>
default = 0. If test_fixture_dbi = 1, output data together in one 'fixture.yaml', and yaml structure is Test::Fixture::DBI.

=back

=head1 SEE ALSO

L<dbix_yaml_dumper.pl>, L<Test::Fixture::DBI>, L<DBIx::FixtureLoader>

=head1 LICENSE

Copyright (C) Hiroyuki Akabane.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hiroyuki Akabane E<lt>hirobanex@gmail.comE<gt>

=for stopwords dsn

=cut

