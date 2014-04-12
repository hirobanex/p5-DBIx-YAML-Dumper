requires 'perl', '5.008001';
requires 'DBI';
requires 'DBIx::Inspector','0.12';
requires 'YAML::Syck','1.27';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Requires';
    requires 'Test::Output';
};

