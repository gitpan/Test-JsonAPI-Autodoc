#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use HTTP::Request::Common;
use HTTP::Response;
use Path::Tiny;
use Test::Mock::LWP::Conditional;

use Test::More;
use Test::JsonAPI::Autodoc;

BEGIN {
    $ENV{TEST_MORE_AUTODOC} = 1;
}

my $tempdir = Path::Tiny->tempdir;
set_documents_path($tempdir);

my $ok_res = HTTP::Response->new(200);
$ok_res->content('{ "message" : "success" }');
$ok_res->content_type('application/json');

my $bad_res = HTTP::Response->new(400);

Test::Mock::LWP::Conditional->stub_request(
    "/foobar" => $ok_res,
    "/bad"    => $bad_res,
);

subtest '200 OK' => sub {
    describe 'POST /foobar' => sub {
        my $req = POST '/foobar';
        $req->header('Content-Type' => 'application/json');
        $req->content(q{
            {
                "id": 1,
                "message": "blah blah"
            }
        });
        http_ok($req, 200, "get message ok");
    };

};

subtest '400 Bad Request' => sub {
    describe 'POST /bad' => sub {
        my $req = POST '/bad';
        $req->header('Content-Type' => 'application/json');
        $req->content(q{
            {
                "id": 1,
                "message": "blah blah"
            }
        });
        http_ok($req, 400, "get 400 ok");
    };
};

(my $filename = path($0)->basename) =~ s/\.t$//;
$filename .= '.md';
my $fh = path("$tempdir/$filename")->openr_utf8;

chomp (my $generated_at_line = <$fh>);
<$fh>; # blank
like $generated_at_line, qr/generated at: \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/, 'generated at ok';
my $got      = do { local $/; <$fh> };
my $expected = do { local $/; <DATA> };
is $got, $expected, 'result ok';

done_testing;
__DATA__
## POST /foobar

get message ok

### parameters

__application/json__

- `id`: Number (e.g. 1)
- `message`: String (e.g. "blah blah")

### request

POST /foobar

### response

```
Status: 200
Response:
{
   "message" : "success"
}

```

## POST /bad

get 400 ok

### parameters

__application/json__

- `id`: Number (e.g. 1)
- `message`: String (e.g. "blah blah")

### request

POST /bad

### response

```
Status: 400
Response:
400 URL must be absolute

```

