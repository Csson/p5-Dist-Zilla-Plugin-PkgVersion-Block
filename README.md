# NAME

Dist::Zilla::Plugin::PkgVersion::Block - PkgVersion for block packages

# VERSION

Version 0.0103, released 2015-01-15.

# SYNOPSIS

    # dist.ini
    [PkgVersion::Block]

# DESCRIPTION

This plugin turns:

    package My::Package {
        ...
    }

into:

    package My::Package 0.01 {
        ...
    }

for all packages in the distribution.

The block package syntax was introduced in Perl 5.14, so this plugin is only usable in projects that only support 5.14+.

There are no attributes. However:

- Having an existing assignment to $VERSION in the file is a fatal error.
- Packages with a version number between the namespace and the block are silently skipped.

# KNOWN PROBLEMS

In files with more than one package block it is currently necessary to end (all but the last) package blocks with a semicolon. Otherwise only the first package will get a version number:

    package My::Package {
        ...
    };

    package My::Package::Other {
        ...
    }

# SEE ALSO

- [Dist::Zilla::Plugin::PkgVersion](https://metacpan.org/pod/Dist::Zilla::Plugin::PkgVersion) (on which this is based)
- [Dist::Zilla::Plugin::OurPkgVersion](https://metacpan.org/pod/Dist::Zilla::Plugin::OurPkgVersion)

# SOURCE

[https://github.com/Csson/p5-Dist-Zilla-Plugin-PkgVersion-Block](https://github.com/Csson/p5-Dist-Zilla-Plugin-PkgVersion-Block)

# HOMEPAGE

[https://metacpan.org/release/Dist-Zilla-Plugin-PkgVersion-Block](https://metacpan.org/release/Dist-Zilla-Plugin-PkgVersion-Block)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Erik Carlsson <info@code301.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
