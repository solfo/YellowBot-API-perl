package YellowBot::API::Request;
use Moose;
use URI ();
use Digest::SHA qw(hmac_sha256_hex);
use HTTP::Request ();
use namespace::clean -except => 'meta';

use YellowBot::API::Response;

has 'api' => (
   isa => 'YellowBot::API',
   is  => 'ro',
   required => 1,
);

has method => (
   isa => 'Str',
   required => 1,
   is  => 'ro',
);

has args => (
   isa => 'HashRef[Str]',
   is  => 'rw',
);

sub http_request {
    my $self = shift;
    my $uri = URI->new( $self->api->server );
    $uri->path("/api/" . $self->method );
    my %args = (%{ $self->args },
                api_key => $self->api->api_key,
               );

    $args{api_ts}  = time;
    $args{api_sig} = hmac_sha256_hex(_get_parameter_string(\%args), $self->api->api_secret);

    $uri->query_form( %args );

    my $content = $uri->query;
    $uri->query('');

    my $request = HTTP::Request->new(POST => $uri);

    $request->header('Content-Type' => 'application/x-www-form-urlencoded');
    if (defined($content)) {
        $request->header('Content-Length' => length($content));
        $request->content($content);
    }

    return $request;
}

sub _get_parameter_string {
    my $args = shift;

    my $str = "";
    for my $key (sort {$a cmp $b} keys %{$args}) {
        next if $key eq 'api_sig';
        my $value = (defined($args->{$key})) ? $args->{$key} : "";
        $str .= $key . $value;
    }
    return $str;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

YellowBot::API::Request - Request object for YellowBot::API

=head1 SYNOPSIS

This class manages setting up requests for the YellowBot::API,
including signing of requests.

No user servicable parts inside.  This part of the API is subject to change.


    my $req = YellowBot::API::Request->new
       (api    => $yellowbot_api,
        method => 'location/detail',
        args   => { foo => 'bar',
                    fob => 123,
                  },
       );
 
    my $http_request = $req->http_request; 


=head1 METHODS

=head2 api

=head2 http_request

Returns a HTTP::Request version of the request.

=head1 AUTHOR

Ask Bjørn Hansen, C<< <ask at develooper.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Solfo Inc, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

