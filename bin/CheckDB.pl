#!/usr/bin/perl -w
# --
# CheckDB.pl - to check the db access
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CheckDB.pl,v 1.1 2002-01-12 14:12:21 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

use lib '/opt/OpenTRS/';
 
use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

use Kernel::Config;
use Kernel::System::Syslog;
use Kernel::System::DB;

my $LogObject = Kernel::System::Syslog->new();
my $ConfigObject = Kernel::Config->new(
    LogObject => $LogObject,
);
my $DBObject = Kernel::System::DB->new(
    LogObject => $ConfigObject,
    ConfigObject => $ConfigObject,
);

if ($DBObject) {
    $DBObject->Prepare(SQL => "SELECT * FROM valid");
    my $Check = 0;
    while (my @RowTmp = $DBObject->FetchrowArray()) {
        $Check++;
    }
    if (!$Check) {
        print "No initial inserts found!";
        exit (1);
    }
    else {
        print "It looks Ok!";
        exit (0);
    }
}
else {
    print "No database connect!";
    exit (1);
}
