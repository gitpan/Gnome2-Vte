package Gnome2::Vte;

# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gnome2-Vte/Vte.pm,v 1.1 2003/11/25 21:28:00 kaffeetisch Exp $

use 5.008;
use strict;
use warnings;

use Gtk2 -init;

require DynaLoader;

our @ISA = qw(DynaLoader);

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

Gnome2::Vte -> bootstrap($VERSION);

1;
__END__

=head1 NAME

Gnome2::Vte - Perl interface to the VTE library

=head1 SYNOPSIS

  use Gnome2::Wnck;
  Gtk2 -> init();

  my $screen = Gnome2::Wnck::Screen -> get_default();
  $screen -> force_update();

  my $pager = Gnome2::Wnck::Pager -> new($screen);
  my $tasklist = Gnome2::Wnck::Tasklist -> new($screen);

=head1 ABSTRACT

This module allows a Perl developer to use the Window Navigator Construction
Kit library (libwnck for short) to write tasklists and pagers.

=head1 SEE ALSO

L<Gtk2>, L<Gtk2::api> and the source code of libwnck.

=head1 AUTHOR

Torsten Schoenfeld E<lt>kaffeetisch@web.deE<gt>

=cut
