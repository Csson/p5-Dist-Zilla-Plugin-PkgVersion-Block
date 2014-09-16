package Dist::Zilla::Plugin::PkgVersion::Block {

    use 5.14.0;
    use Moose;
    with('Dist::Zilla::Role::FileMunger',
         'Dist::Zilla::Role::FileFinderUser' => { default_finders => [':InstallModules', ':ExecFiles'] },
         'Dist::Zilla::Role::PPI'
    );

    use PPI;
    use MooseX::Types::Perl qw/StrictVersionStr/;
    use namespace::sweep;

    has die_on_existing_version => (
        is => 'ro',
        isa => 'Bool',
        default => 0,
    );

    sub BUILD {
        my $self = shift;
        if(!StrictVersionStr->check($self->zilla->version)) {
            Carp::croak("Version does not conform to the strict version string format.") ;
        }
        return $self;
    }

    sub munge_files {
        my($self) = @_;
        $self->munge_file($_) for @{ $self->found_files };
    }

    sub munge_file {
        my $self = shift;
        my $file = shift;

        if($file->is_bytes) {
            $self->log_debug([ "%s has 'bytes' encoding, skipping...", $file->name ]);
            return;
        }
        return $self->munge_perl($file);
    }

    sub munge_perl {
        my $self = shift;
        my $file = shift;

        my $document = $self->ppi_document_for_file($file);

        return if !$self->check_no_existing_version($file, $document);

        my $package_statements = $self->check_package_statements($file, $document);
        return if !$package_statements;

        my %seen;
        my $munged = 0;

        STATEMENT:
        for my $stmt (@{ $package_statements }) {
            my $package = $stmt->namespace;
            if($seen{ $package }++) {
                # log
                next STATEMENT;
            }
            if($stmt->content =~ m{ package \s* (?:\#.*)? \n \s* \Q$package}x ) {
                # log
                next STATEMENT;
            }
            if($package =~ m{\P{ASCII}}) {
                # log
            }

            my $version_token = PPI::Token::Comment->new(' ' . $self->zilla->version . ' ');
            $stmt->insert_after($version_token);
            $munged = 1;
        }

    }


    sub check_no_existing_version {
        my $self = shift;
        my $file = shift;
        my $document = shift;

        if($self->document_assigns_to_variable($document, '$VERSION')) {
            if($self->die_on_existing_version) {
                $self->log_fatal([ 'existing assignment to $VERSION in %s ', $file->name ]);
            }
            $self->log([ 'skipping %s: assigns to $VERSION', $file->name ]);
            return 0;
        }
        return 1;
    }

    sub check_package_statements {
        my $self = shift;
        my $file = shift;
        my $document = shift;

        my $statements = $document->find('PPI::Statement::Package');
        if(!$statements) {
            $self->log_debug([ 'skipping %s: no package statement found', $file->name ]);
        }
        return $statements;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::PkgVersion::Block - Blah blah blah

=head1 SYNOPSIS

  use Dist::Zilla::Plugin::PkgVersion::Block;

=head1 DESCRIPTION

Dist::Zilla::Plugin::PkgVersion::Block is

=head1 AUTHOR

Erik Carlsson E<lt>info@code301.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
