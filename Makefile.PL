#!/usr/bin/perl -w
use 5.008;
use strict;

use ExtUtils::MakeMaker;
use Cwd;
use File::Spec;

# $Id: Makefile.PL 52 2008-11-15 13:21:24Z tsch $

our %build_reqs = (
  'perl-ExtUtils-Depends'   => '0.20',
  'perl-ExtUtils-PkgConfig' => '1.03',
  'perl-Glib'               => '1.01',
  'perl-Gtk2'               => '1.00',
  'Vte'                     => '0.10',
);

our %perl_reqs = (
  'Glib'                => $build_reqs{'perl-Glib'},
  'Gtk2'                => $build_reqs{'perl-Gtk2'},
  'ExtUtils::Depends'   => $build_reqs{'perl-ExtUtils-Depends'},
  'ExtUtils::PkgConfig' => $build_reqs{'perl-ExtUtils-PkgConfig'},
);

unless (eval "use ExtUtils::Depends '$build_reqs{'perl-ExtUtils-Depends'}';"
           . "use ExtUtils::PkgConfig '$build_reqs{'perl-ExtUtils-PkgConfig'}';"
           . "use Glib '$build_reqs{'perl-Glib'}';"
           . "use Gtk2 '$build_reqs{'perl-Gtk2'}';"
           . "use Glib::MakeHelper;"
           . "use Gtk2::CodeGen;"
           . "1") {
  warn "$@\n";
  WriteMakefile(
    PREREQ_FATAL => 1,
    PREREQ_PM    => \%perl_reqs,
  );
  exit 1; # not reached
}

my %pkgcfg;
unless (eval { %pkgcfg = ExtUtils::PkgConfig->find("vte >= $build_reqs{'Vte'}");
	       1; })
{
  warn $@;
  exit 0;
}

mkdir 'build', 0777;

our @xs_files = <xs/*.xs>;
our %pod_files = (
	'Vte.pm' => '$(INST_MAN3DIR)/Gnome2::Vte.$(MAN3EXT)',
	Glib::MakeHelper->do_pod_files (@xs_files),
);

Gtk2::CodeGen->parse_maps('vte2perl');
Gtk2::CodeGen->write_boot(ignore => qr/^Gnome2::Vte$/);

ExtUtils::PkgConfig->write_version_macros (
  "build/vte2perl-version.h",
  "vte" => "VTE",
);

my $vte = ExtUtils::Depends->new('Gnome2::Vte', 'Gtk2');
$vte->set_inc($pkgcfg{cflags});
$vte->set_libs($pkgcfg{libs});
$vte->add_xs(@xs_files);
$vte->add_pm('Vte.pm' => '$(INST_LIBDIR)/Vte.pm');
$vte->add_typemaps(map {File::Spec->catfile(cwd(), $_)} 'build/vte2perl.typemap');

$vte->install(qw(vte2perl.h build/vte2perl-autogen.h build/vte2perl-version.h));
$vte->save_config('build/IFiles.pm');

WriteMakefile(
  NAME          => 'Gnome2::Vte',
  VERSION_FROM  => 'Vte.pm', # finds $VERSION
  ABSTRACT_FROM => 'Vte.pm', # retrieve abstract from module
  XSPROTOARG    => '-noprototypes',
  MAN3PODS      => \%pod_files,
  PREREQ_PM     => \%perl_reqs,
  META_MERGE    => { configure_requires => \%perl_reqs },
  $vte->get_makefile_vars,
);

sub MY::postamble {
	return Glib::MakeHelper->postamble_clean ()
	     . Glib::MakeHelper->postamble_docs_full (
		DEPENDS => $vte,
		COPYRIGHT_FROM => 'copyright.pod')
	     . Glib::MakeHelper->postamble_rpms (
		'GNOME_VTE' => $build_reqs{'Vte'},
		'PERL_EXTUTILS_DEPENDS' =>
			$build_reqs{'perl-ExtUtils-Depends'},
		'PERL_EXTUTILS_PKGCONFIG' =>
			$build_reqs{'perl-ExtUtils-PkgConfig'},
		'PERL_GLIB' => $build_reqs{'perl-Glib'},
		'PERL_GTK' => $build_reqs{'perl-Gtk2'},
	       );
}
