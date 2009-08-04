package YellowBot::API::Request;
use Moose;
use URI ();
use Digest::SHA qw(hmac_sha256_hex);
use HTTP::Request ();
use namespace::clean;

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
    if ($args{api_user_identifier}) {
        $args{api_ts}  = time;
        $args{api_sig} = hmac_sha256_hex(_get_parameter_string(\%args), $self->api->api_secret);
    }
    $uri->query_form( %args );
    return HTTP::Request->new(GET => $uri);
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


1;
