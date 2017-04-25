#!/usr/bin/perl
#define strings in perl 

use strict;
use warnings;
use Excel::Writer::XLSX;
#read login date and time 
open(LOGON, "<logon.txt");

#read logout date and time 
open(LOGOFF, "<logout.txt");

#save login data to the @login array
my @login = <LOGON>;
#save logout data to the @logout array
my @logout = <LOGOFF>; 
#select(STDOUT);

my $workbook  = Excel::Writer::XLSX->new( 'worktime.xlsx' );
my $worksheet = $workbook->add_worksheet();

my @logindate;
my @logoutdate;
my @logintime;
my @logouttime;
my @Workhour; 
#@days = split(' ',$login[3]);
my $i=0;
foreach my $loopitem (@login)
{ 
	my @days = split(' ',$loopitem);
	$logindate[$i] = $days[1];
	$logintime[$i] = $days[2];
	$i++;
}

  $i=0;
foreach my $loopitem (@logout)
{
	my @days = split(' ',$loopitem);
	$logoutdate[$i] = $days[1];
	$logouttime[$i] = $days[2];
	$i++;
}
my $format = $workbook->add_format();
$format->set_bold();
$format->set_color('black');
$format->set_align('center');
$format->set_size('12');
$format->set_text_wrap();

my $format1 =$workbook->add_format();
$format1->set_align('center');

$worksheet->write(0,0,"Date",$format);
$worksheet->write(0,1,"Login Time",$format);
$worksheet->write(0,2,"Logout Time",$format);
$worksheet->write(0,3,"Work hours",$format);
$worksheet->set_column( 'A:C', 15 );
my $row=1;
for(my $j=0; $j < @logindate; $j++)
{

	for(my $jj=0; $jj < @logoutdate; $jj++)
	{

		if($logindate[$j] eq $logoutdate[$jj])
		{
			my $CalcTime = Timefind($logintime[$j],$logouttime[$jj]);
			
			$worksheet->write($row,0,$logoutdate[$jj],$format1);
			$worksheet->write($row,1,$logintime[$j],$format1);
			$worksheet->write($row,2,$logouttime[$jj],$format1);
			$worksheet->write($row,3,$CalcTime,$format1);
			$row++;
		}
	}
}

#calculate the number of working hours 
sub Timefind 
{
	my $workhours;
	my $workminutes; 
	my $totalminutes;
	my @Timelogin = split(':',$_[0]);
	my @Timelogout = split(':',$_[1]);
	
	if($Timelogout[1] >= $Timelogin[1])
	{
		$workhours = $Timelogout[0] - $Timelogin[0];
		$workminutes = $Timelogout[1]-$Timelogin[1];
		$totalminutes = (($workhours * 60) + $workminutes) - 30; 
		$workhours = int($totalminutes / 60);
		$workminutes = $totalminutes % 60; 
	}
	else
	{
		$workminutes = ($Timelogout[1]-$Timelogin[1])+60;
		$workhours = $Timelogout[0] - $Timelogin[0] - 1;
		$totalminutes = (($workhours * 60) + $workminutes); 
		$workhours = int($totalminutes / 60);
		$workminutes = $totalminutes % 60; 
	}
	
	return ($workhours . ':' .$workminutes);
}

