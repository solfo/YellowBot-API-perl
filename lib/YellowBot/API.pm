package YellowBot::API;

use warnings;
use strict;
use Moose;
use LWP::UserAgent;

use namespace::clean -except => 'meta';

use YellowBot::API::Request;

our $VERSION = '0.01';

has 'api_key' => (
    isa => 'Str',
    is  => 'ro',
    required => 1,
);

has 'api_secret' => (
    isa => 'Str',
    is  => 'ro',
);

has 'server' => (
    isa => 'Str',
    is  => 'rw',
    default => 'http://www.yellowbot.com',
);

has 'ua' => (
    is  => 'rw',
    isa => 'LWP::UserAgent',
    lazy_build => 1,
);

sub _build_ua {
    my $self = shift;
    LWP::UserAgent->new();
}

sub request {
    my ($self, $method, %args) = @_;
    return YellowBot::API::Request->new(
        method => $method,
        args   => \%args,
        api    => $self,
    );

}

sub call {
    my $self = shift;
    my $http_response = $self->ua->request( $self->request(@_)->http_request );
    return YellowBot::API::Response->new(http => $http_response);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

YellowBot::API - The great new YellowBot::API!

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use YellowBot::API;

    my $foo = YellowBot::API->new();
    ...

=head1 METHODS

=head2 function1

=head1 AUTHOR

Ask Bjørn Hansen, C<< <ask at develooper.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-yellowbot-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=YellowBot-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc YellowBot::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=YellowBot-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/YellowBot-API>

=item * Search CPAN

L<http://search.cpan.org/dist/YellowBot-API/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Solfo, Inc, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

