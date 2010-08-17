package YellowBot::API;

use warnings;
use strict;
use Moose;
use LWP::UserAgent;

use namespace::clean -except => 'meta';

use YellowBot::API::Request;

has 'api_key' => (
    isa => 'Str',
    is  => 'ro',
    required => 1,
);

has 'api_secret' => (
    isa => 'Str',
    is  => 'ro',
    required => 1,
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
    my $ua = LWP::UserAgent->new();
    $ua->env_proxy;
    return $ua;
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
    return YellowBot::API::Response->new(http => $http_response)->data;
}

__PACKAGE__->meta->make_immutable;

local ($YellowBot::API::VERSION) = ('devel') unless defined $YellowBot::API::VERSION;

1;

__END__

=head1 NAME

YellowBot::API - The great new YellowBot::API!

=head1 SYNOPSIS

    use YellowBot::API;

    my $yp = YellowBot::API->new
       (api_key    => $api_key,
        api_secret => $api_secret,
       );

    # if you are in Canada...
    # $yp->server('http://www.weblocal.ca/');

    my $data = $api->call('location/details',
                          id           => '/solfo-burbank-ca.html'
                          api_version  => 1,
                          get_pictures => 10,
                         );
    print $data->{name}, "\n";
    for my $p ( @{ $data->{pictures} } ) {
       print $p->{url}, "\n";
    }


=head1 METHODS

=head2 call( $endpoint, %args )

Calls the endpoint (see the YellowBot API documentation) with the
specified arguments.  Returns a hash data structure with the API
results.


=head1 DEBUGGING

If the API_DEBUG environment variable is set to a true value (1 for
example) the request query and the response will be printed to STDERR.


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

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Solfo, Inc, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

