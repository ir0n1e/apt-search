#!/usr/bin/env perl

package Functions;

use strict;
use warnings;

use Term::ANSIColor qw(:constants);
use Glib qw(TRUE FALSE);
use IO::Prompt;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(ask_user check_root check_error print_err print_warn print_ok);

##Variables
#Size of TTY
my ($rows, $columns) = split(/ /, qx(stty size));


# check if we have root permissions
sub check_root
{
    if ($< != 0)
    {
        my $col = BOLD RED, ' * ';
        print STDERR "\n".$col, RESET,
            "Nothing was executed, because a heuristic shows that root permissions \n",
            RESET;
        print STDERR $col, RESET,
            "are required to execute everything successfully.\n\n", RESET;

    exit(1);
    }
}

#check apt output for errors and warnings
sub check_error ($)
{
    my ($line) = @_;
    my $string  = '';
    
    chomp($line);
    if ($line =~ /(W:\s)(.*)/mg)
    {
        &print_warn($2);
        return TRUE;
    }
    elsif ($line =~ /(E:\s)(.*)/mg)
    {
        &print_err($2);
        return TRUE;
    }
    return FALSE;
}

#Error massage
sub print_err ($)
{
    my ($string) = @_;
    my $e_suffix = BOLD BLUE '[ ', BOLD RED '!!', BOLD BLUE ' ]', RESET;
    my $e_prefix = BOLD RED ' * ', RESET;
    my $count_w = ($columns - length($string) - 9);   

    print STDERR  $e_prefix.$string. ' ' x $count_w.$e_suffix."\n";
}

#Warning massage
sub print_warn ($)
{
    my ($string) = @_;
    my $w_prefix = BOLD YELLOW ' * ', RESET; 

    print STDERR  $w_prefix.$string."\n";

}

#OK massage
sub print_ok ($)
{
    my ($string) = @_;
    my $ok_suffix = BOLD BLUE '[ ', BOLD GREEN 'OK', BOLD BLUE ' ]', RESET;
    my $ok_prefix = BOLD GREEN ' * ', RESET;
    my $count_w = ($columns - length($string) - 9);   
    
    print $ok_prefix.$string. ' ' x $count_w.$ok_suffix."\n";
}

sub ask_user ($)
{
    my ($string) = @_;
    my $question;

    $question = BOLD WHITE,"\n\n$string",
          RESET, " [", BOLD GREEN, "Yes", RESET, "/", BOLD RED, "No", RESET,
          "] ";
        if (!prompt($question, -yn1,
            -default => 'y',
            -prompt => "$question",    ))
        {
            print "\nQuitting.\n";
            exit;
        }

}


return 1;

__END__

=head1 NAME

Functions.pm: This file is part of /home/ir0n1e/apt-search.git

=head1 AUTHOR

Sacha Bartuweit 'Ir0n1E' E<lt>ir0n1e@freenet.deE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (C) 2010 Sacha Bartuweit 'Ir0n1E' <ir0n1e@freenet.de>
 

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

=head1 DATE

Mai 21, 2010 05:32:54

=cut

# vi:ts=4:sw=4:ai:expandtab
