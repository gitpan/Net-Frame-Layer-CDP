use Test;
BEGIN { plan(tests => 3) }

use Net::Frame::Layer::CDP::VTPDomain;

my $l = Net::Frame::Layer::CDP::VTPDomain->new;
$l->pack;
$l->unpack;

print $l->print."\n";

my $encap = $l->encapsulate;
$encap ? print "[$encap]\n" : print "[none]\n";

ok(1);

my $NO_HAVE_NetFrameSimple = 0;
eval "use Net::Frame::Simple 1.05";
if($@) {
    $NO_HAVE_NetFrameSimple = "Net::Frame::Simple 1.05 required";
}

use Net::Frame::Layer::CDP qw(:consts);

my ($cdp, $VtpDomain, $packet, $decode, $expectedOutput);

$cdp = Net::Frame::Layer::CDP->new;
$VtpDomain = Net::Frame::Layer::CDP::VTPDomain->new;

$expectedOutput = 'CDP: version:2  ttl:180  checksum:0x0000
CDP::VTPDomain: type:0x0009  length:4  VtpDomain:';

print $cdp->print . "\n";
print $VtpDomain->print . "\n";
print "\n";

ok(($cdp->print . "\n" . $VtpDomain->print) eq $expectedOutput);

skip ($NO_HAVE_NetFrameSimple,
sub {
$packet = pack "H*", "02b47ba20009000e5654505f444f4d41494e";

$decode = Net::Frame::Simple->new(
    raw => $packet,
    firstLayer => 'CDP'
);

$expectedOutput = 'CDP: version:2  ttl:180  checksum:0x7ba2
CDP::VTPDomain: type:0x0009  length:14  VtpDomain:VTP_DOMAIN';

print $decode->print;
print "\n";

$decode->print eq $expectedOutput;
});
