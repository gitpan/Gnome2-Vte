package Gnome2::Vte;

# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gnome2-Vte/Vte.pm,v 1.8 2004/06/04 23:32:18 kaffeetisch Exp $

use 5.008;
use strict;
use warnings;

use Gtk2;

require DynaLoader;

our @ISA = qw(DynaLoader);

our $VERSION = '0.03';

sub import {
  my $self = shift();
  $self -> VERSION(@_);
}

sub dl_load_flags { 0x01 }

Gnome2::Vte -> bootstrap($VERSION);

1;
__END__

=head1 NAME

Gnome2::Vte - Perl interface to the Virtual Terminal Emulation library

=head1 SYNOPSIS

  use Gnome2::Vte;

  my $window = Gtk2::Window -> new("toplevel");
  my $terminal = Gnome2::Vte::Terminal -> new();

  $window -> add($terminal);
  $window -> show_all();

  Gtk2 -> main();

=head1 ABSTRACT

This module allows a Perl developer to use the Virtual Terminal Emulator
library (libvte for short).

=head1 SEE ALSO

L<Gnome2::Vte::index>(3pm), L<Gtk2>(3pm), L<Gtk2::api>(3pm) and
L<http://developer.gnome.org/doc/API/2.0/vte/>.

=head1 AUTHOR

Torsten Schoenfeld E<lt>kaffeetisch@web.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2003 by the gtk2-perl team

=cut
