#!/usr/bin/perl -w
use strict;
use Test::More;
use Gnome2::Vte;

# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gnome2-Vte/t/VteTerminal.t,v 1.5 2004/06/04 23:26:45 kaffeetisch Exp $

unless (Gtk2 -> init_check()) {
  plan skip_all => "Couldn't initialize Gtk2";
}
else {
  plan tests => 25;
}

###############################################################################

my $number = qr/^\d+$/;

###############################################################################

my $window = Gtk2::Window -> new("toplevel");

my $terminal = Gnome2::Vte::Terminal -> new();
isa_ok($terminal, "Gnome2::Vte::Terminal");

$window -> add($terminal);
$window -> show_all();

$terminal -> im_append_menuitems(Gtk2::Menu -> new());

like($terminal -> fork_command("/bin/ls",
                               ["/bin/ls", "--color", "-l", "bin"],
                               ["TERM=xterm-color"],
                               "/",
                               0, 0, 0), $number);

$terminal -> feed("BLA!\n");
$terminal -> feed_child("BOH!\n");
$terminal -> copy_clipboard();
$terminal -> paste_clipboard();
$terminal -> copy_primary();
$terminal -> paste_primary();
$terminal -> set_size(81, 25);

$terminal -> set_audible_bell(1);
is($terminal -> get_audible_bell(), 1);

$terminal -> set_visible_bell(1);
is($terminal -> get_visible_bell(), 1);

$terminal -> set_allow_bold(1);
is($terminal -> get_allow_bold(), 1);

$terminal -> set_scroll_on_output(1);
$terminal -> set_scroll_on_keystroke(1);

my $white = Gtk2::Gdk::Color -> new(0xFFFF, 0xFFFF, 0xFFFF);
my $black = Gtk2::Gdk::Color -> new(0, 0, 0);

$terminal -> set_color_bold($black);
$terminal -> set_color_foreground($black);
$terminal -> set_color_background($white);
$terminal -> set_color_dim($black);
$terminal -> set_colors($black, $white, [$white, $black, $white, $black, $white, $black, $white, $black]);

SKIP: {
  skip("set_color_cursor and set_color_highlight are new in 0.11.11", 0)
    unless (Gnome2::Vte -> CHECK_VERSION(0, 11, 11));

  $terminal -> set_color_cursor($black);
  $terminal -> set_color_highlight($black);
}

$terminal -> set_default_colors();

# $terminal -> set_background_image();
# $terminal -> set_background_image_file();
$terminal -> set_background_saturation(0.5);
$terminal -> set_background_transparent(0.5);

SKIP: {
  skip("set_tint_color and set_scroll_background are new in 0.11.0", 0)
    unless (Gnome2::Vte -> CHECK_VERSION(0, 11, 0));

  $terminal -> set_background_tint_color($black);
  $terminal -> set_scroll_background(1);
}

$terminal -> set_cursor_blinks(1);
$terminal -> set_scrollback_lines(100);

$terminal -> set_font(Gtk2::Pango::FontDescription -> from_string("Monospace 10"));
$terminal -> set_font_from_string("Sans 12");

SKIP: {
  skip("set_font_full and set_font_from_string_full are new in 0.10.11", 0)
    unless (Gnome2::Vte -> CHECK_VERSION(0, 11, 11));

  $terminal -> set_font_full(Gtk2::Pango::FontDescription -> from_string("Monospace 10"), "use-default");
  $terminal -> set_font_from_string_full("Sans 12", "force-disable");
}

isa_ok($terminal -> get_font(), "Gtk2::Pango::FontDescription");

like($terminal -> get_using_xft(), qr/^(?:|1)$/);
ok(not $terminal -> get_has_selection());

$terminal -> set_word_chars("/");
ok($terminal -> is_word_char("/"));

$terminal -> set_backspace_binding("ascii-backspace");
$terminal -> set_delete_binding("ascii-delete");

$terminal -> set_mouse_autohide(1);
ok($terminal -> get_mouse_autohide());

my ($text, $attributes) = $terminal -> get_text(sub { 1; });
ok(defined($text));
isa_ok($attributes, "ARRAY");

($text, $attributes) = $terminal -> get_text_range(0, 0, 10, 10, sub { 1; });
ok(defined($text));
isa_ok($attributes, "ARRAY");

is_deeply([$terminal -> get_cursor_position()], [0, 0]);

$terminal -> match_clear_all();

my $id = $terminal -> match_add(".*");

# $terminal -> match_check(0, 10);

SKIP: {
  skip("match_set_cursor is new in 0.11.0", 0)
    unless (Gnome2::Vte -> CHECK_VERSION(0, 11, 0));

  $terminal -> match_set_cursor($id, Gtk2::Gdk::Cursor -> new("arrow"));
}

SKIP: {
  skip("match_set_cursor_type is new in 0.11.9", 0)
    unless (Gnome2::Vte -> CHECK_VERSION(0, 11, 9));

  $terminal -> match_set_cursor_type($id, "arrow");
}

$terminal -> match_remove($id);

$terminal -> set_emulation("xterm-color");
is($terminal -> get_emulation(), "xterm-color");

$terminal -> set_encoding("ISO-8859-15");
is($terminal -> get_encoding(), "ISO-8859-15");

# $terminal -> get_status_line();

is_deeply([$terminal -> get_padding()], [2, 2]);

isa_ok($terminal -> get_adjustment(), "Gtk2::Adjustment");
like($terminal -> get_char_ascent(), $number);
like($terminal -> get_char_descent(), $number);
like($terminal -> get_char_height(), $number);
like($terminal -> get_char_width(), $number);
like($terminal -> get_column_count(), $number);
# $terminal -> get_icon_title();
like($terminal -> get_row_count(), $number);
# $terminal -> get_window_title();

$terminal -> reset(1, 1);
