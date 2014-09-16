requires 'perl', '5.14.0';

requires 'namespace::sweep', '0.006';
requires 'Moose', '0.92';
requires 'PPI', '1.215';
requires 'MooseX::Types::Perl', '0';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Test::DZil', '0';
    requires 'autodie', '2.00';
};
