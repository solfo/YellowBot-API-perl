package YellowBot::API::Response;
use Moose;
use JSON::XS qw(decode_json);
use namespace::clean -except => 'meta';

has http => (
   is  => 'ro',
   isa => 'HTTP::Response',
   required => 1,
);

has data => (
   is   => 'ro', 
   isa  => 'HashRef',
   lazy_build => 1,
);

sub _build_data {
    my $self = shift;
    unless ($self->http->code == 200) {
        return +{ error_code => $self->http->code,
                  error      => $self->http->status_line,
                };
    }
    return decode_json($self->http->content);
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

