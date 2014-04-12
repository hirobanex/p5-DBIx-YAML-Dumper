use strict;
use warnings;
use utf8;
use Test::More;
use Test::Requires {
    'DBD::SQLite' => 1.31
};
use DBIx::YAML::Dumper;
use File::Temp;
use Test::Output;

my $dir = File::Temp::tempdir(CLEANUP => 0);
my $dsn = "dbi:SQLite:$dir/test.db";

my $dbh = DBI->connect($dsn, '', '', {RaiseError => 1}) or die;
    
$dbh->do(q{
    create table post (
        post_id int unsigned not null primary key,
        user_id int,
        body varchar(255)
    );
});

$dbh->do(q{ INSERT INTO post (post_id,user_id,body) VALUES (1,1,"hoge"),(2,1,"moge"),(3,2,'foo'); });
$dbh->do(q{
    create table user (
        user_id int unsigned not null,
        name varchar(255)
    );
});
$dbh->do(q{ INSERT INTO user (user_id,name) VALUES (1,"hiro"),(2,"banex"); });

$dbh->do(q{
    create table age (
        user_id int unsigned not null,
        body int
    );
});
$dbh->do(q{ INSERT INTO user (user_id,name) VALUES (1,25),(2,35); });

subtest 'all table dump case' => sub {
    stdout_like {
        DBIx::YAML::Dumper->new_with_option("-d$dsn", "-o$dir")->run;
    } qr/write /;

    ok -f "$dir/post.yaml";
    ok -f "$dir/user.yaml";
    ok -f "$dir/age.yaml";
};

subtest 'indicate tables case' => sub {
    $dir = File::Temp::tempdir(CLEANUP => 0);

    stdout_like {
        DBIx::YAML::Dumper->new_with_option("-d$dsn", "-o$dir","-tpost","-tage")->run;
    } qr/write /;

    ok -f "$dir/post.yaml";
    ok !-f "$dir/user.yaml";
    ok -f "$dir/age.yaml";
};

subtest 'test_fixture_dbi' => sub {
    $dir = File::Temp::tempdir(CLEANUP => 0);

    stdout_like {
        DBIx::YAML::Dumper->new_with_option("-d$dsn", "-o$dir",'-f')->run;
    } qr/write all table to /;

    ok !-f "$dir/post.yaml";
    ok !-f "$dir/user.yaml";
    ok !-f "$dir/age.yaml";
    ok -f "$dir/fixture.yaml";
};

done_testing;

